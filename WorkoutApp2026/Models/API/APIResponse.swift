//
//  APIResponse.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

// MARK: - Generic Paginated Response

struct PaginatedResponse<T: Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}

// MARK: - Type Aliases for Common Responses

typealias ExerciseResponse = PaginatedResponse<Exercise>
typealias ExerciseInfoResponse = PaginatedResponse<ExerciseInfo>
typealias MuscleResponse = PaginatedResponse<Muscle>
typealias EquipmentResponse = PaginatedResponse<Equipment>
typealias ExerciseCategoryResponse = PaginatedResponse<ExerciseCategory>
typealias IngredientResponse = PaginatedResponse<Ingredient>
typealias NutritionPlanResponse = PaginatedResponse<NutritionPlan>
typealias MealResponse = PaginatedResponse<Meal>
typealias RoutineResponse = PaginatedResponse<Routine>
typealias DayResponse = PaginatedResponse<Day>
typealias WorkoutSessionResponse = PaginatedResponse<WorkoutSession>
typealias WorkoutLogResponse = PaginatedResponse<WorkoutLog>
typealias LanguageResponse = PaginatedResponse<Language>
typealias WeightEntryResponse = PaginatedResponse<WeightEntry>
typealias MeasurementCategoryResponse = PaginatedResponse<MeasurementCategory>
typealias MeasurementEntryResponse = PaginatedResponse<MeasurementEntry>
typealias GalleryImageResponse = PaginatedResponse<GalleryImage>
typealias SlotResponse = PaginatedResponse<Slot>
typealias SlotEntryResponse = PaginatedResponse<SlotEntry>
typealias ExerciseImageResponse = PaginatedResponse<ExerciseImage>
typealias ExerciseVideoResponse = PaginatedResponse<ExerciseVideo>
typealias LicenseResponse = PaginatedResponse<License>
