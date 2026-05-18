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
    let nameEn: String?
    let isFront: Bool
    let imageUrlMain: String?
    let imageUrlSecondary: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameEn = "name_en"
        case isFront = "is_front"
        case imageUrlMain = "image_url_main"
        case imageUrlSecondary = "image_url_secondary"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        nameEn = try container.decodeIfPresent(String.self, forKey: .nameEn)
        isFront = try container.decodeIfPresent(Bool.self, forKey: .isFront) ?? false
        imageUrlMain = try container.decodeIfPresent(String.self, forKey: .imageUrlMain)
        imageUrlSecondary = try container.decodeIfPresent(String.self, forKey: .imageUrlSecondary)
    }
}
