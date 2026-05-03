//
//  SDWorkoutLog.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDWorkoutLog {
    @Attribute(.unique) var id: UUID
    var remoteId: Int?  // Wger API ID if synced
    var setNumber: Int
    var reps: Int?
    var weight: Double?
    var weightUnit: String  // "kg" or "lb"
    var rir: Int?  // Reps in reserve
    var isCompleted: Bool
    var timestamp: Date
    var notes: String?

    var session: SDWorkoutSession?
    var exercise: SDExercise?

    init(
        setNumber: Int,
        reps: Int? = nil,
        weight: Double? = nil,
        weightUnit: String = "kg",
        exercise: SDExercise? = nil
    ) {
        self.id = UUID()
        self.setNumber = setNumber
        self.reps = reps
        self.weight = weight
        self.weightUnit = weightUnit
        self.exercise = exercise
        self.isCompleted = false
        self.timestamp = Date()
    }

    // MARK: - Computed Properties

    var volume: Double? {
        guard let reps = reps, let weight = weight else { return nil }
        return Double(reps) * weight
    }

    var formattedWeight: String {
        guard let weight = weight else { return "--" }
        return String(format: "%.1f %@", weight, weightUnit)
    }

    var formattedSet: String {
        let repsStr = reps.map { "\($0)" } ?? "--"
        let weightStr = weight.map { String(format: "%.1f", $0) } ?? "--"
        return "\(repsStr) x \(weightStr) \(weightUnit)"
    }
}
