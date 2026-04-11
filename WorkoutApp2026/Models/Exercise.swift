//
//  Exercise.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Exercise: Codable, Identifiable, Hashable {
    let id: Int
    let uuid: String
    let created: String
    let lastUpdate: String
    let category: Int
    let muscles: [Int]
    let musclesSecondary: [Int]
    let equipment: [Int]
    let variations: Int?
    let licenseAuthor: String?

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case created
        case lastUpdate = "last_update"
        case category
        case muscles
        case musclesSecondary = "muscles_secondary"
        case equipment
        case variations
        case licenseAuthor = "license_author"
    }
}
