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
    let created: String?
    let lastUpdate: String?
    let lastUpdateGlobal: String?
    let category: ExerciseCategory
    let muscles: [Muscle]
    let musclesSecondary: [Muscle]
    let equipment: [Equipment]
    let license: License?
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String(id)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        lastUpdate = try container.decodeIfPresent(String.self, forKey: .lastUpdate)
        lastUpdateGlobal = try container.decodeIfPresent(String.self, forKey: .lastUpdateGlobal)
        category = try container.decodeIfPresent(ExerciseCategory.self, forKey: .category) ?? ExerciseCategory(id: 0, name: "Strength")
        muscles = try container.decodeIfPresent([Muscle].self, forKey: .muscles) ?? []
        musclesSecondary = try container.decodeIfPresent([Muscle].self, forKey: .musclesSecondary) ?? []
        equipment = try container.decodeIfPresent([Equipment].self, forKey: .equipment) ?? []
        license = try container.decodeIfPresent(License.self, forKey: .license)
        licenseAuthor = try container.decodeIfPresent(String.self, forKey: .licenseAuthor)
        images = try container.decodeIfPresent([ExerciseImage].self, forKey: .images) ?? []
        videos = try container.decodeIfPresent([ExerciseVideo].self, forKey: .videos) ?? []
        translations = try container.decodeIfPresent([ExerciseTranslation].self, forKey: .translations) ?? []
        variations = try container.decodeIfPresent(Int.self, forKey: .variations)
        authorHistory = try container.decodeIfPresent([String].self, forKey: .authorHistory) ?? []
        totalAuthorsHistory = try container.decodeIfPresent([String].self, forKey: .totalAuthorsHistory) ?? []
    }
}
