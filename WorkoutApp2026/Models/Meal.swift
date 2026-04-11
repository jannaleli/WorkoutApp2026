//
//  Meal.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Meal: Codable, Identifiable, Hashable {
    let id: Int
    let plan: Int
    let order: Int
    let name: String
    let time: String?
    let mealItems: [MealItem]?

    enum CodingKeys: String, CodingKey {
        case id
        case plan
        case order
        case name
        case time
        case mealItems = "meal_items"
    }
}

struct MealItem: Codable, Identifiable, Hashable {
    let id: Int
    let meal: Int
    let ingredient: Int
    let order: Int
    let amount: String
    let weightUnit: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case meal
        case ingredient
        case order
        case amount
        case weightUnit = "weight_unit"
    }
}

struct NutritionDiary: Codable, Identifiable, Hashable {
    let id: Int
    let plan: Int
    let ingredient: Int
    let weightUnit: Int?
    let datetime: String
    let amount: String

    enum CodingKeys: String, CodingKey {
        case id
        case plan
        case ingredient
        case weightUnit = "weight_unit"
        case datetime
        case amount
    }
}
