//
//  SDRoutine.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDRoutine {
    @Attribute(.unique) var id: UUID
    var remoteId: Int?  // Wger API ID if synced
    var name: String
    var routineDescription: String?
    var created: Date
    var lastUsed: Date?
    var isTemplate: Bool
    var isPublic: Bool

    @Relationship(deleteRule: .cascade, inverse: \SDWorkoutSession.routine)
    var sessions: [SDWorkoutSession]?

    init(
        name: String,
        description: String? = nil,
        isTemplate: Bool = false,
        remoteId: Int? = nil
    ) {
        self.id = UUID()
        self.remoteId = remoteId
        self.name = name
        self.routineDescription = description
        self.created = Date()
        self.isTemplate = isTemplate
        self.isPublic = false
    }

    var sessionCount: Int {
        sessions?.count ?? 0
    }

    var lastSessionDate: Date? {
        sessions?.max(by: { $0.date < $1.date })?.date
    }
}
