//
//  SDExercise.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDExercise {
    @Attribute(.unique) var id: Int  // Wger API ID
    var uuid: String
    var name: String
    var exerciseDescription: String?
    var categoryId: Int
    var categoryName: String?
    var muscleIds: [Int]
    var muscleSecondaryIds: [Int]
    var equipmentIds: [Int]
    var imageURLs: [String]
    var videoURLs: [String]
    var created: Date
    var lastUpdated: Date
    var isFavorite: Bool

    var muscleGroup: SDMuscleGroup?

    @Relationship(deleteRule: .cascade, inverse: \SDWorkoutLog.exercise)
    var workoutLogs: [SDWorkoutLog]?

    init(
        id: Int,
        uuid: String,
        name: String,
        description: String? = nil,
        categoryId: Int,
        categoryName: String? = nil,
        muscleIds: [Int] = [],
        muscleSecondaryIds: [Int] = [],
        equipmentIds: [Int] = [],
        imageURLs: [String] = [],
        videoURLs: [String] = []
    ) {
        self.id = id
        self.uuid = uuid
        self.name = name
        self.exerciseDescription = description
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.muscleIds = muscleIds
        self.muscleSecondaryIds = muscleSecondaryIds
        self.equipmentIds = equipmentIds
        self.imageURLs = imageURLs
        self.videoURLs = videoURLs
        self.created = Date()
        self.lastUpdated = Date()
        self.isFavorite = false
    }

    // Computed property to get the first image URL
    var primaryImageURL: URL? {
        guard let first = imageURLs.first else { return nil }
        return URL(string: first)
    }

    // Computed property to get all muscles (primary + secondary)
    var allMuscleIds: [Int] {
        muscleIds + muscleSecondaryIds
    }
}

