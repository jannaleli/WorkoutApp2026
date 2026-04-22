//
//  WorkoutService.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

// MARK: - Protocol
protocol WorkoutServiceProtocol: Sendable {
    // Sessions
    func getAllSessions() async throws -> [SDWorkoutSession]
    func getRecentSessions(limit: Int) async throws -> [SDWorkoutSession]
    func startNewSession(routine: SDRoutine?) async throws -> SDWorkoutSession
    func finishSession(_ session: SDWorkoutSession) async throws
    func deleteSession(_ session: SDWorkoutSession) async throws

    // Logs
    func addSet(to session: SDWorkoutSession, exercise: SDExercise, reps: Int?, weight: Double?, weightUnit: String) async throws -> SDWorkoutLog
    func updateLog(_ log: SDWorkoutLog, reps: Int?, weight: Double?) async throws
    func deleteLog(_ log: SDWorkoutLog) async throws

    // Routines
    func getAllRoutines() async throws -> [SDRoutine]
    func createRoutine(name: String, description: String?) async throws -> SDRoutine
    func deleteRoutine(_ routine: SDRoutine) async throws

    // Stats
    func getWeeklyStats() async throws -> WeeklyStats
    func getTotalStats() async throws -> TotalStats
}

// MARK: - Stats Models
struct WeeklyStats {
    let workoutCount: Int
    let totalDuration: TimeInterval
    let totalSets: Int
    let totalVolume: Double
    let daysWorkedOut: Set<Int>  // Day of week (1-7)

    static let empty = WeeklyStats(workoutCount: 0, totalDuration: 0, totalSets: 0, totalVolume: 0, daysWorkedOut: [])
}

struct TotalStats {
    let totalWorkouts: Int
    let totalDuration: TimeInterval
    let totalSets: Int
    let totalVolume: Double
    let favoriteExercises: [SDExercise]
    let currentStreak: Int

    static let empty = TotalStats(totalWorkouts: 0, totalDuration: 0, totalSets: 0, totalVolume: 0, favoriteExercises: [], currentStreak: 0)
}

// MARK: - Implementation
final class WorkoutService: WorkoutServiceProtocol, @unchecked Sendable {
    private let repository: WorkoutRepositoryProtocol

    init(repository: WorkoutRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Sessions

    func getAllSessions() async throws -> [SDWorkoutSession] {
        try await repository.getAllSessions()
    }

    func getRecentSessions(limit: Int) async throws -> [SDWorkoutSession] {
        try await repository.getRecentSessions(limit: limit)
    }

    func startNewSession(routine: SDRoutine?) async throws -> SDWorkoutSession {
        let session = try await repository.createSession(routine: routine)
        session.start()
        try await repository.updateSession(session)
        return session
    }

    func finishSession(_ session: SDWorkoutSession) async throws {
        session.finish()
        try await repository.updateSession(session)
    }

    func deleteSession(_ session: SDWorkoutSession) async throws {
        try await repository.deleteSession(session)
    }

    // MARK: - Logs

    func addSet(to session: SDWorkoutSession, exercise: SDExercise, reps: Int?, weight: Double?, weightUnit: String) async throws -> SDWorkoutLog {
        let existingLogs = try await repository.getLogsForSession(session)
        let setNumber = existingLogs.filter { $0.exercise?.id == exercise.id }.count + 1

        let log = SDWorkoutLog(
            setNumber: setNumber,
            reps: reps,
            weight: weight,
            weightUnit: weightUnit,
            exercise: exercise
        )

        try await repository.addLog(log, to: session)
        return log
    }

    func updateLog(_ log: SDWorkoutLog, reps: Int?, weight: Double?) async throws {
        if let reps = reps { log.reps = reps }
        if let weight = weight { log.weight = weight }
        log.isCompleted = (reps != nil && weight != nil)
        try await repository.updateLog(log)
    }

    func deleteLog(_ log: SDWorkoutLog) async throws {
        try await repository.deleteLog(log)
    }

    // MARK: - Routines

    func getAllRoutines() async throws -> [SDRoutine] {
        try await repository.getAllRoutines()
    }

    func createRoutine(name: String, description: String?) async throws -> SDRoutine {
        try await repository.createRoutine(name: name, description: description)
    }

    func deleteRoutine(_ routine: SDRoutine) async throws {
        try await repository.deleteRoutine(routine)
    }

    // MARK: - Stats

    func getWeeklyStats() async throws -> WeeklyStats {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            return .empty
        }

        let sessions = try await getAllSessions()
        let weekSessions = sessions.filter { $0.date >= weekStart && $0.isCompleted }

        let totalDuration = weekSessions.compactMap { $0.duration }.reduce(0, +)
        let totalSets = weekSessions.reduce(0) { $0 + $1.totalSets }
        let totalVolume = weekSessions.reduce(0) { $0 + $1.totalVolume }

        let daysWorkedOut = Set(weekSessions.compactMap { session -> Int? in
            calendar.component(.weekday, from: session.date)
        })

        return WeeklyStats(
            workoutCount: weekSessions.count,
            totalDuration: totalDuration,
            totalSets: totalSets,
            totalVolume: totalVolume,
            daysWorkedOut: daysWorkedOut
        )
    }

    func getTotalStats() async throws -> TotalStats {
        let sessions = try await getAllSessions()
        let completedSessions = sessions.filter { $0.isCompleted }

        let totalDuration = completedSessions.compactMap { $0.duration }.reduce(0, +)
        let totalSets = completedSessions.reduce(0) { $0 + $1.totalSets }
        let totalVolume = completedSessions.reduce(0) { $0 + $1.totalVolume }

        // Calculate current streak
        let streak = calculateStreak(from: completedSessions)

        // Find favorite exercises (most frequently used)
        let allLogs = completedSessions.flatMap { $0.logs ?? [] }
        let exerciseCounts = Dictionary(grouping: allLogs.compactMap { $0.exercise }, by: { $0.id })
        let favorites = exerciseCounts.sorted { $0.value.count > $1.value.count }
            .prefix(3)
            .compactMap { $0.value.first }

        return TotalStats(
            totalWorkouts: completedSessions.count,
            totalDuration: totalDuration,
            totalSets: totalSets,
            totalVolume: totalVolume,
            favoriteExercises: favorites,
            currentStreak: streak
        )
    }

    // MARK: - Private Helpers

    private func calculateStreak(from sessions: [SDWorkoutSession]) -> Int {
        let calendar = Calendar.current
        let sortedDates = sessions.map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)  // Most recent first

        guard let mostRecent = sortedDates.first else { return 0 }

        // Check if we worked out today or yesterday (streak still valid)
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        guard mostRecent >= yesterday else { return 0 }

        var streak = 0
        var checkDate = mostRecent

        for date in sortedDates {
            if date == checkDate {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if date < checkDate {
                break
            }
        }

        return streak
    }
}
