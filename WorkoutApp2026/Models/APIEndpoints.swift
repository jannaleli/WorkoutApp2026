//
//  APIEndpoints.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

enum WgerAPI {
    static let baseURL = "https://wger.de/api/v2"

    // MARK: - Exercise Endpoints

    enum Exercises {
        static let exercise = "\(baseURL)/exercise/"
        static let exerciseInfo = "\(baseURL)/exerciseinfo/"
        static let exerciseCategory = "\(baseURL)/exercisecategory/"
        static let exerciseImage = "\(baseURL)/exerciseimage/"
        static let exerciseVideo = "\(baseURL)/video/"
        static let exerciseComment = "\(baseURL)/exercisecomment/"
        static let exerciseAlias = "\(baseURL)/exercisealias/"
        static let exerciseTranslation = "\(baseURL)/exercise-translation/"
        static let exerciseVariation = "\(baseURL)/variation/"

        static func exercise(id: Int) -> String {
            "\(baseURL)/exercise/\(id)/"
        }

        static func exerciseInfo(id: Int) -> String {
            "\(baseURL)/exerciseinfo/\(id)/"
        }
    }

    // MARK: - Equipment & Muscle Endpoints

    enum EquipmentMuscle {
        static let equipment = "\(baseURL)/equipment/"
        static let muscle = "\(baseURL)/muscle/"

        static func equipment(id: Int) -> String {
            "\(baseURL)/equipment/\(id)/"
        }

        static func muscle(id: Int) -> String {
            "\(baseURL)/muscle/\(id)/"
        }
    }

    // MARK: - Workout Endpoints

    enum Workouts {
        static let routine = "\(baseURL)/routine/"
        static let day = "\(baseURL)/day/"
        static let slot = "\(baseURL)/slot/"
        static let slotEntry = "\(baseURL)/slot-entry/"
        static let workoutSession = "\(baseURL)/workoutsession/"
        static let workoutLog = "\(baseURL)/workoutlog/"
        static let templates = "\(baseURL)/templates/"
        static let publicTemplates = "\(baseURL)/public-templates/"

        static func routine(id: Int) -> String {
            "\(baseURL)/routine/\(id)/"
        }

        static func day(id: Int) -> String {
            "\(baseURL)/day/\(id)/"
        }
    }

    // MARK: - Nutrition Endpoints

    enum Nutrition {
        static let ingredient = "\(baseURL)/ingredient/"
        static let ingredientInfo = "\(baseURL)/ingredientinfo/"
        static let nutritionPlan = "\(baseURL)/nutritionplan/"
        static let nutritionPlanInfo = "\(baseURL)/nutritionplaninfo/"
        static let meal = "\(baseURL)/meal/"
        static let mealItem = "\(baseURL)/mealitem/"
        static let nutritionDiary = "\(baseURL)/nutritiondiary/"
        static let weightUnit = "\(baseURL)/weightunit/"
        static let ingredientWeightUnit = "\(baseURL)/ingredientweightunit/"

        static func ingredient(id: Int) -> String {
            "\(baseURL)/ingredient/\(id)/"
        }

        static func nutritionPlan(id: Int) -> String {
            "\(baseURL)/nutritionplan/\(id)/"
        }
    }

    // MARK: - User & Tracking Endpoints

    enum UserTracking {
        static let userProfile = "\(baseURL)/userprofile/"
        static let weightEntry = "\(baseURL)/weightentry/"
        static let measurementCategory = "\(baseURL)/measurement-category/"
        static let measurement = "\(baseURL)/measurement/"
        static let gallery = "\(baseURL)/gallery/"
    }

    // MARK: - Settings & Miscellaneous

    enum Settings {
        static let language = "\(baseURL)/language/"
        static let license = "\(baseURL)/license/"
        static let repetitionUnit = "\(baseURL)/setting-repetitionunit/"
        static let weightUnit = "\(baseURL)/setting-weightunit/"
    }
}
