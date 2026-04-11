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
    let url: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case shortName = "short_name"
        case url
    }
}
