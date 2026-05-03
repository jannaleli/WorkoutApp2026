//
//  Slot.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Slot: Codable, Identifiable, Hashable {
    let id: Int
    let day: Int
    let order: Int
    let comment: String?
}

struct SlotEntry: Codable, Identifiable, Hashable {
    let id: Int
    let slot: Int
    let exerciseBase: Int
    let order: Int
    let comment: String?
    let repetitionUnit: Int
    let repetitionRounding: String?
    let weightUnit: Int
    let weightRounding: String?
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case slot
        case exerciseBase = "exercise_base"
        case order
        case comment
        case repetitionUnit = "repetition_unit"
        case repetitionRounding = "repetition_rounding"
        case weightUnit = "weight_unit"
        case weightRounding = "weight_rounding"
        case type
    }
}
