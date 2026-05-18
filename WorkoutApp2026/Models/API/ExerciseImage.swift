//
//  ExerciseImage.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct ExerciseImage: Codable, Identifiable, Hashable {
    let id: Int
    let uuid: String
    let exerciseBase: Int
    let image: String
    let isMain: Bool
    let style: String
    let license: Int
    let licenseAuthor: String?
    let authorHistory: [String]
    let isAiGenerated: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case exerciseBase = "exercise_base"
        case image
        case isMain = "is_main"
        case style
        case license
        case licenseAuthor = "license_author"
        case authorHistory = "author_history"
        case isAiGenerated = "is_ai_generated"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String(id)
        exerciseBase = try container.decodeIfPresent(Int.self, forKey: .exerciseBase) ?? 0
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        isMain = try container.decodeIfPresent(Bool.self, forKey: .isMain) ?? false
        style = try container.decodeIfPresent(String.self, forKey: .style) ?? ""
        license = try container.decodeIfPresent(Int.self, forKey: .license) ?? 0
        licenseAuthor = try container.decodeIfPresent(String.self, forKey: .licenseAuthor)
        authorHistory = try container.decodeIfPresent([String].self, forKey: .authorHistory) ?? []
        isAiGenerated = try container.decodeIfPresent(Bool.self, forKey: .isAiGenerated)
    }
}
