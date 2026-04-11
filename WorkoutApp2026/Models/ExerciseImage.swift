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
}
