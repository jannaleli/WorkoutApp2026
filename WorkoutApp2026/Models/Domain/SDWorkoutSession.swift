//
//  SDWorkoutSession.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDWorkoutSession {
    @Attribute(.unique) var id: UUID
    var remoteId: Int?  // Wger API ID if synced
    var date: Date
    var notes: String?
    var duration: TimeInterval?
    var impression: String?  // "good", "neutral", "bad"
    var isCompleted: Bool
    var startTime: Date?
    var endTime: Date?

    var routine: SDRoutine?

    @Relationship(deleteRule: .cascade, inverse: \SDWorkoutLog.session)
    var logs: [SDWorkoutLog]?

    init(
        date: Date = Date(),
        notes: String? = nil,
        routine: SDRoutine? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.notes = notes
        self.routine = routine
        self.isCompleted = false
    }

    // MARK: - Computed Properties

    var totalSets: Int {
        logs?.count ?? 0
    }

    var totalReps: Int {
        logs?.compactMap { $0.reps }.reduce(0, +) ?? 0
    }

    var totalVolume: Double {
        logs?.compactMap { log -> Double? in
            guard let reps = log.reps, let weight = log.weight else { return nil }
            return Double(reps) * weight
        }.reduce(0, +) ?? 0
    }

    var uniqueExerciseCount: Int {
        Set(logs?.compactMap { $0.exercise?.id } ?? []).count
    }

    var formattedDuration: String {
        guard let duration = duration else { return "--:--" }
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return String(format: "%d:%02d hr", hours, minutes)
        } else {
            return String(format: "%d min", minutes)
        }
    }

    // MARK: - Methods

    func start() {
        startTime = Date()
    }

    func finish() {
        endTime = Date()
        if let start = startTime, let end = endTime {
            duration = end.timeIntervalSince(start)
        }
        isCompleted = true
    }
}
