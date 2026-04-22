//
//  SDCacheMetadata.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDCacheMetadata {
    @Attribute(.unique) var key: String
    var lastFetched: Date
    var expiresAt: Date
    var itemCount: Int
    var etag: String?

    init(key: String, ttlMinutes: Int = 60, itemCount: Int = 0) {
        self.key = key
        self.lastFetched = Date()
        self.expiresAt = Date().addingTimeInterval(TimeInterval(ttlMinutes * 60))
        self.itemCount = itemCount
    }

    var isExpired: Bool {
        Date() > expiresAt
    }

    var isValid: Bool {
        !isExpired
    }

    func refresh(ttlMinutes: Int = 60, itemCount: Int? = nil) {
        self.lastFetched = Date()
        self.expiresAt = Date().addingTimeInterval(TimeInterval(ttlMinutes * 60))
        if let count = itemCount {
            self.itemCount = count
        }
    }
}

// MARK: - Cache Keys
extension SDCacheMetadata {
    static func key(for muscleGroup: MuscleGroupType) -> String {
        "exercises_\(muscleGroup.rawValue)"
    }

    static let musclesKey = "muscles"
    static let equipmentKey = "equipment"
    static let categoriesKey = "categories"
}
