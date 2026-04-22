//
//  WorkoutSession.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct WorkoutSession: Codable, Identifiable, Hashable {
    let id: Int
    let routine: Int
    let day: Int?
    let date: String
    let notes: String?
    let impression: String?
    let timeStart: String?
    let timeEnd: String?

    enum CodingKeys: String, CodingKey {
        case id
        case routine
        case day
        case date
        case notes
        case impression
        case timeStart = "time_start"
        case timeEnd = "time_end"
    }
}
