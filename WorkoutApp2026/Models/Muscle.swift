//
//  Muscle.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Muscle: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let nameEn: String
    let isFront: Bool
    let imageUrlMain: String
    let imageUrlSecondary: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameEn = "name_en"
        case isFront = "is_front"
        case imageUrlMain = "image_url_main"
        case imageUrlSecondary = "image_url_secondary"
    }
}
