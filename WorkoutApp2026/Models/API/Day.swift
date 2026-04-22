//
//  Day.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Day: Codable, Identifiable, Hashable {
    let id: Int
    let routine: Int
    let name: String
    let description: String
    let order: Int
    let needLogsToAdvance: Bool
    let type: String
    let config: DayConfig?

    enum CodingKeys: String, CodingKey {
        case id
        case routine
        case name
        case description
        case order
        case needLogsToAdvance = "need_logs_to_advance"
        case type
        case config
    }
}

struct DayConfig: Codable, Hashable {
    let day: Int?
    let daysOfWeek: [Int]?

    enum CodingKeys: String, CodingKey {
        case day
        case daysOfWeek = "days_of_week"
    }
}
