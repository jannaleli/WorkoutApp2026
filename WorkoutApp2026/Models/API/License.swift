//
//  License.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct License: Codable, Identifiable, Hashable {
    let id: Int
    let fullName: String
    let shortName: String
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case shortName = "short_name"
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
