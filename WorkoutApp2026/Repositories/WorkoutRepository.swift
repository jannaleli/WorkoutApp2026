//
//  WorkoutRepository.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

// MARK: - Protocol
protocol WorkoutRepositoryProtocol: Sendable {
    // Sessions
    func getAllSessions() async throws -> [SDWorkoutSession]
    func getSession(id: UUID) async throws -> SDWorkoutSession?
    func getRecentSessions(limit: Int) async throws -> [SDWorkoutSession]
    func createSession(routine: SDRoutine?) async throws -> SDWorkoutSession
    func updateSession(_ session: SDWorkoutSession) async throws
    func deleteSession(_ session: SDWorkoutSession) async throws

    // Logs
    func getLogsForSession(_ session: SDWorkoutSession) async throws -> [SDWorkoutLog]
    func addLog(_ log: SDWorkoutLog, to session: SDWorkoutSession) async throws
    func updateLog(_ log: SDWorkoutLog) async throws
    func deleteLog(_ log: SDWorkoutLog) async throws

    // Routines
    func getAllRoutines() async throws -> [SDRoutine]
    func getRoutine(id: UUID) async throws -> SDRoutine?
    func createRoutine(name: String, description: String?) async throws -> SDRoutine
    func updateRoutine(_ routine: SDRoutine) async throws
    func deleteRoutine(_ routine: SDRoutine) async throws
}

// MARK: - Implementation
final class WorkoutRepository: WorkoutRepositoryProtocol, @unchecked Sendable {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Sessions

    func getAllSessions() async throws -> [SDWorkoutSession] {
        let descriptor = FetchDescriptor<SDWorkoutSession>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func getSession(id: UUID) async throws -> SDWorkoutSession? {
        let descriptor = FetchDescriptor<SDWorkoutSession>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }

    func getRecentSessions(limit: Int) async throws -> [SDWorkoutSession] {
        var descriptor = FetchDescriptor<SDWorkoutSession>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func createSession(routine: SDRoutine?) async throws -> SDWorkoutSession {
        let session = SDWorkoutSession(date: Date(), routine: routine)
        modelContext.insert(session)
        try modelContext.save()
        return session
    }

    func updateSession(_ session: SDWorkoutSession) async throws {
        try modelContext.save()
    }

    func deleteSession(_ session: SDWorkoutSession) async throws {
        modelContext.delete(session)
        try modelContext.save()
    }

    // MARK: - Logs

    func getLogsForSession(_ session: SDWorkoutSession) async throws -> [SDWorkoutLog] {
        return session.logs?.sorted(by: { $0.timestamp < $1.timestamp }) ?? []
    }

    func addLog(_ log: SDWorkoutLog, to session: SDWorkoutSession) async throws {
        log.session = session
        modelContext.insert(log)
        try modelContext.save()
    }

    func updateLog(_ log: SDWorkoutLog) async throws {
        try modelContext.save()
    }

    func deleteLog(_ log: SDWorkoutLog) async throws {
        modelContext.delete(log)
        try modelContext.save()
    }

    // MARK: - Routines

    func getAllRoutines() async throws -> [SDRoutine] {
        let descriptor = FetchDescriptor<SDRoutine>(
            sortBy: [SortDescriptor(\.created, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func getRoutine(id: UUID) async throws -> SDRoutine? {
        let descriptor = FetchDescriptor<SDRoutine>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }

    func createRoutine(name: String, description: String?) async throws -> SDRoutine {
        let routine = SDRoutine(name: name, description: description)
        modelContext.insert(routine)
        try modelContext.save()
        return routine
    }

    func updateRoutine(_ routine: SDRoutine) async throws {
        try modelContext.save()
    }

    func deleteRoutine(_ routine: SDRoutine) async throws {
        modelContext.delete(routine)
        try modelContext.save()
    }
}
