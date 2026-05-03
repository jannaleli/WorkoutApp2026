//
//  SDMuscleGroup.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Muscle Group Type Enum
enum MuscleGroupType: String, CaseIterable, Codable, Hashable {
    case chest
    case back
    case shoulders
    case arms
    case core
    case legs
    case glutes
    case calves

    var displayName: String {
        rawValue.capitalized
    }

    var tag: String {
        switch self {
        case .chest, .shoulders: return "Push"
        case .back: return "Pull"
        case .arms, .core: return "Iso"
        case .legs, .glutes, .calves: return "Lower"
        }
    }

    var color: Color {
        switch self {
        case .chest: return ColorPalette.chestColor
        case .back: return ColorPalette.backColor
        case .shoulders: return ColorPalette.shouldersColor
        case .arms: return ColorPalette.armsColor
        case .core: return ColorPalette.coreColor
        case .legs: return ColorPalette.legsColor
        case .glutes: return ColorPalette.glutesColor
        case .calves: return ColorPalette.calvesColor
        }
    }

    var iconColor: Color {
        switch self {
        case .chest: return ColorPalette.chestIconColor
        case .back: return ColorPalette.backIconColor
        case .shoulders: return ColorPalette.shouldersIconColor
        case .arms: return ColorPalette.armsIconColor
        case .core: return ColorPalette.coreIconColor
        case .legs: return ColorPalette.legsIconColor
        case .glutes: return ColorPalette.glutesIconColor
        case .calves: return ColorPalette.calvesIconColor
        }
    }

    var tagBackgroundColor: Color {
        switch tag {
        case "Push": return ColorPalette.pushTagBackground
        case "Pull": return ColorPalette.pullTagBackground
        case "Iso": return ColorPalette.isoTagBackground
        case "Lower": return ColorPalette.lowerTagBackground
        default: return ColorPalette.backgroundSecondary
        }
    }

    var tagTextColor: Color {
        switch tag {
        case "Push": return ColorPalette.pushTagText
        case "Pull": return ColorPalette.pullTagText
        case "Iso": return ColorPalette.isoTagText
        case "Lower": return ColorPalette.lowerTagText
        default: return ColorPalette.textSecondary
        }
    }

    var systemIconName: String {
        switch self {
        case .chest: return "figure.arms.open"
        case .back: return "figure.walk"
        case .shoulders: return "figure.boxing"
        case .arms: return "figure.strengthtraining.traditional"
        case .core: return "figure.core.training"
        case .legs: return "figure.run"
        case .glutes: return "figure.dance"
        case .calves: return "figure.stairs"
        }
    }

    // Map to Wger muscle IDs
    var muscleIds: [Int] {
        switch self {
        case .chest: return [4]      // Pectoralis major
        case .back: return [12, 9]   // Latissimus dorsi, Trapezius
        case .shoulders: return [2]  // Anterior deltoid
        case .arms: return [1, 5]    // Biceps, Triceps
        case .core: return [6, 14]   // Rectus abdominis, Obliques
        case .legs: return [10, 11]  // Quadriceps, Hamstrings
        case .glutes: return [8]     // Gluteus maximus
        case .calves: return [7, 15] // Gastrocnemius, Soleus
        }
    }
}

// MARK: - SwiftData Model
@Model
final class SDMuscleGroup {
    @Attribute(.unique) var id: UUID
    var type: String  // Maps to MuscleGroupType.rawValue
    var exerciseCount: Int
    var lastUpdated: Date

    @Relationship(deleteRule: .nullify, inverse: \SDExercise.muscleGroup)
    var exercises: [SDExercise]?

    init(type: MuscleGroupType, exerciseCount: Int = 0) {
        self.id = UUID()
        self.type = type.rawValue
        self.exerciseCount = exerciseCount
        self.lastUpdated = Date()
    }

    var muscleGroupType: MuscleGroupType? {
        MuscleGroupType(rawValue: type)
    }
}
