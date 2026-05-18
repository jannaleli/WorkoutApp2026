//
//  Route.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftUI

// MARK: - App Routes
enum Route: Hashable {
    // Home
    case home

    // Exercises
    case exerciseList(muscleGroup: MuscleGroupType)
    case exerciseDetail(exerciseId: Int)
    case exerciseSearch

    // Workouts
    case workoutBuilder
    case activeWorkout(sessionId: UUID)
    case routineList
    case routineDetail(routineId: UUID)

    // History
    case history
    case workoutSummary(sessionId: UUID)

    // Profile
    case profile
    case settings
    case editProfile
}

// MARK: - Tab Enum
enum AppTab: Int, CaseIterable, Identifiable {
    case home = 0
    case history = 1
    case build = 2
    case profile = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .history: return "History"
        case .build: return "Build"
        case .profile: return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .history: return "clock.fill"
        case .build: return "plus.circle.fill"
        case .profile: return "person.fill"
        }
    }

    var iconNameInactive: String {
        switch self {
        case .home: return "house"
        case .history: return "clock"
        case .build: return "plus.circle"
        case .profile: return "person"
        }
    }
}
