//
//  ExerciseInfo.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct ExerciseInfo: Codable, Identifiable, Hashable {
    let id: Int
    let uuid: String
    let created: String
    let lastUpdate: String
    let lastUpdateGlobal: String
    let category: ExerciseCategory
    let muscles: [Muscle]
    let musclesSecondary: [Muscle]
    let equipment: [Equipment]
    let license: License
    let licenseAuthor: String?
    let images: [ExerciseImage]
    let videos: [ExerciseVideo]
    let translations: [ExerciseTranslation]
    let variations: Int?
    let authorHistory: [String]
    let totalAuthorsHistory: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case created
        case lastUpdate = "last_update"
        case lastUpdateGlobal = "last_update_global"
        case category
        case muscles
        case musclesSecondary = "muscles_secondary"
        case equipment
        case license
        case licenseAuthor = "license_author"
        case images
        case videos
        case translations
        case variations
        case authorHistory = "author_history"
        case totalAuthorsHistory = "total_authors_history"
    }
}
