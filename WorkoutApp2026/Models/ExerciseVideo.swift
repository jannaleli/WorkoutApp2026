//
//  ExerciseVideo.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct ExerciseVideo: Codable, Identifiable, Hashable {
    let id: Int
    let uuid: String
    let exerciseBase: Int
    let video: String
    let isMain: Bool
    let size: Int
    let duration: String
    let width: Int
    let height: Int
    let codec: String
    let codecLong: String
    let license: Int
    let licenseAuthor: String?
    let authorHistory: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case exerciseBase = "exercise_base"
        case video
        case isMain = "is_main"
        case size
        case duration
        case width
        case height
        case codec
        case codecLong = "codec_long"
        case license
        case licenseAuthor = "license_author"
        case authorHistory = "author_history"
    }
}
