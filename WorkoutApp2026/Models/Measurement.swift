//
//  Measurement.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct MeasurementCategory: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let unit: String
}

struct MeasurementEntry: Codable, Identifiable, Hashable {
    let id: Int
    let category: Int
    let date: String
    let value: String
    let notes: String?
}
