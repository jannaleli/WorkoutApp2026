//
//  NutritionPlan.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct NutritionPlan: Codable, Identifiable, Hashable {
    let id: Int
    let description: String
    let creationDate: String
    let hasGoalCalories: Bool
    let goalEnergy: Int?
    let goalProtein: Int?
    let goalCarbohydrates: Int?
    let goalFat: Int?
    let goalFiber: Int?
    let goalSodium: Int?
    let onlyLogging: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case creationDate = "creation_date"
        case hasGoalCalories = "has_goal_calories"
        case goalEnergy = "goal_energy"
        case goalProtein = "goal_protein"
        case goalCarbohydrates = "goal_carbohydrates"
        case goalFat = "goal_fat"
        case goalFiber = "goal_fiber"
        case goalSodium = "goal_sodium"
        case onlyLogging = "only_logging"
    }
}

struct NutritionPlanInfo: Codable, Identifiable, Hashable {
    let id: Int
    let description: String
    let creationDate: String
    let hasGoalCalories: Bool
    let goalEnergy: Int?
    let goalProtein: Int?
    let goalCarbohydrates: Int?
    let goalFat: Int?
    let goalFiber: Int?
    let goalSodium: Int?
    let onlyLogging: Bool
    let meals: [Meal]

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case creationDate = "creation_date"
        case hasGoalCalories = "has_goal_calories"
        case goalEnergy = "goal_energy"
        case goalProtein = "goal_protein"
        case goalCarbohydrates = "goal_carbohydrates"
        case goalFat = "goal_fat"
        case goalFiber = "goal_fiber"
        case goalSodium = "goal_sodium"
        case onlyLogging = "only_logging"
        case meals
    }
}
