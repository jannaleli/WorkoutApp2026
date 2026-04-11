//
//  Routine.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Routine: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let created: String
    let lastUpdate: String
    let startDate: String?
    let endDate: String?
    let fitInWeek: Bool
    let isPublic: Bool
    let isTemplate: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case created
        case lastUpdate = "last_update"
        case startDate = "start_date"
        case endDate = "end_date"
        case fitInWeek = "fit_in_week"
        case isPublic = "is_public"
        case isTemplate = "is_template"
    }
}
