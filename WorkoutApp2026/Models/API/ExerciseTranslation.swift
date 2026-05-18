//
//  ExerciseTranslation.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct ExerciseTranslation: Codable, Identifiable, Hashable {
    let id: Int
    let uuid: String
    let name: String
    let exerciseBase: Int
    let description: String?
    let language: Int
    let aliases: [ExerciseAlias]
    let notes: [ExerciseComment]
    let licenseAuthor: String?
    let authorHistory: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case name
        case exerciseBase = "exercise_base"
        case description
        case language
        case aliases
        case notes
        case licenseAuthor = "license_author"
        case authorHistory = "author_history"
    }

    private enum FallbackCodingKeys: String, CodingKey {
        case exercise
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fallbackContainer = try decoder.container(keyedBy: FallbackCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String(id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown Exercise"
        exerciseBase = try container.decodeIfPresent(Int.self, forKey: .exerciseBase)
            ?? fallbackContainer.decodeIfPresent(Int.self, forKey: .exercise)
            ?? 0
        description = try container.decodeIfPresent(String.self, forKey: .description)
        language = try container.decodeIfPresent(Int.self, forKey: .language) ?? 2
        aliases = try container.decodeIfPresent([ExerciseAlias].self, forKey: .aliases) ?? []
        notes = try container.decodeIfPresent([ExerciseComment].self, forKey: .notes) ?? []
        licenseAuthor = try container.decodeIfPresent(String.self, forKey: .licenseAuthor)
        authorHistory = try container.decodeIfPresent([String].self, forKey: .authorHistory) ?? []
    }
}

struct ExerciseAlias: Codable, Identifiable, Hashable {
    let id: Int
    let alias: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        alias = try container.decodeIfPresent(String.self, forKey: .alias) ?? ""
    }
}

struct ExerciseComment: Codable, Identifiable, Hashable {
    let id: Int
    let comment: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? ""
    }
}
