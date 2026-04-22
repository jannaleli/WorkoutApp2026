//
//  SDUserProfile.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDUserProfile {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var avatarURL: String?
    var createdAt: Date
    var weightGoal: Double?
    var currentWeight: Double?
    var preferredWeightUnit: String  // "kg" or "lb"
    var weeklyWorkoutGoal: Int
    var email: String?

    init(displayName: String) {
        self.id = UUID()
        self.displayName = displayName
        self.createdAt = Date()
        self.preferredWeightUnit = "kg"
        self.weeklyWorkoutGoal = 3
    }

    // MARK: - Computed Properties

    var initials: String {
        let components = displayName.split(separator: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }

    var hasSetGoals: Bool {
        weightGoal != nil || weeklyWorkoutGoal > 0
    }
}
