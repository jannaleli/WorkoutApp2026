//
//  WorkoutLog.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct WorkoutLog: Codable, Identifiable, Hashable {
    let id: Int
    let routine: Int
    let date: String
    let exerciseBase: Int
    let repetitionUnit: Int
    let reps: Int?
    let weight: String?
    let weightUnit: Int
    let rir: String?

    enum CodingKeys: String, CodingKey {
        case id
        case routine
        case date
        case exerciseBase = "exercise_base"
        case repetitionUnit = "repetition_unit"
        case reps
        case weight
        case weightUnit = "weight_unit"
        case rir
    }
}
