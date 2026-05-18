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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String(id)
        exerciseBase = try container.decodeIfPresent(Int.self, forKey: .exerciseBase) ?? 0
        video = try container.decodeIfPresent(String.self, forKey: .video) ?? ""
        isMain = try container.decodeIfPresent(Bool.self, forKey: .isMain) ?? false
        size = try container.decodeIfPresent(Int.self, forKey: .size) ?? 0
        duration = try container.decodeIfPresent(String.self, forKey: .duration) ?? ""
        width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        codec = try container.decodeIfPresent(String.self, forKey: .codec) ?? ""
        codecLong = try container.decodeIfPresent(String.self, forKey: .codecLong) ?? ""
        license = try container.decodeIfPresent(Int.self, forKey: .license) ?? 0
        licenseAuthor = try container.decodeIfPresent(String.self, forKey: .licenseAuthor)
        authorHistory = try container.decodeIfPresent([String].self, forKey: .authorHistory) ?? []
    }
}
