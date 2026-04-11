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
    let description: String
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
}

struct ExerciseAlias: Codable, Identifiable, Hashable {
    let id: Int
    let alias: String
}

struct ExerciseComment: Codable, Identifiable, Hashable {
    let id: Int
    let comment: String
}
