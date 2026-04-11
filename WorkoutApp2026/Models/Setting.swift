//
//  Setting.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct RepetitionUnit: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct SettingWeightUnit: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
