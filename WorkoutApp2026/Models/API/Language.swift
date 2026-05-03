//
//  Language.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Language: Codable, Identifiable, Hashable {
    let id: Int
    let shortName: String
    let fullName: String
    let fullNameEn: String

    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
        case fullNameEn = "full_name_en"
    }
}
