//
//  WeightEntry.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct WeightEntry: Codable, Identifiable, Hashable {
    let id: Int
    let weight: String
    let date: String
}
