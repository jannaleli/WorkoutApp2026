//
//  WgerEndpoints.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

enum WgerEndpoint: Endpoint {
    // MARK: - Exercises
    case exercises(language: Int?, limit: Int?, offset: Int?)
    case exerciseInfo(id: Int)
    case exerciseInfoList(language: Int?, limit: Int?, offset: Int?)
    case exerciseInfoByMuscle(muscleId: Int, language: Int?, limit: Int?, offset: Int?)
    case exercisesByCategory(categoryId: Int, language: Int?)
    case exercisesByMuscle(muscleId: Int, language: Int?)
    case searchExercises(query: String, language: Int?)

    // MARK: - Muscles
    case muscles
    case muscle(id: Int)

    // MARK: - Equipment
    case equipment
    case equipmentItem(id: Int)

    // MARK: - Categories
    case categories

    // MARK: - Routines
    case routines
    case routine(id: Int)
    case publicTemplates

    // MARK: - Workout Sessions
    case workoutSessions
    case workoutSession(id: Int)

    // MARK: - Workout Logs
    case workoutLogs
    case workoutLog(id: Int)

    // MARK: - Endpoint Implementation
    var path: String {
        switch self {
        case .exercises:
            return "/exercise/"
        case .exerciseInfo(let id):
            return "/exerciseinfo/\(id)/"
        case .exerciseInfoList, .exerciseInfoByMuscle:
            return "/exerciseinfo/"
        case .exercisesByCategory:
            return "/exercise/"
        case .exercisesByMuscle:
            return "/exercise/"
        case .searchExercises:
            return "/exercise/search/"
        case .muscles:
            return "/muscle/"
        case .muscle(let id):
            return "/muscle/\(id)/"
        case .equipment:
            return "/equipment/"
        case .equipmentItem(let id):
            return "/equipment/\(id)/"
        case .categories:
            return "/exercisecategory/"
        case .routines:
            return "/routine/"
        case .routine(let id):
            return "/routine/\(id)/"
        case .publicTemplates:
            return "/public-templates/"
        case .workoutSessions:
            return "/workoutsession/"
        case .workoutSession(let id):
            return "/workoutsession/\(id)/"
        case .workoutLogs:
            return "/workoutlog/"
        case .workoutLog(let id):
            return "/workoutlog/\(id)/"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .exercises(let language, let limit, let offset):
            return buildPaginationQuery(language: language, limit: limit, offset: offset)

        case .exerciseInfoList(let language, let limit, let offset):
            return buildPaginationQuery(language: language, limit: limit, offset: offset)

        case .exerciseInfoByMuscle(let muscleId, let language, let limit, let offset):
            var items = buildPaginationQuery(language: language, limit: limit, offset: offset) ?? []
            items.append(URLQueryItem(name: "muscles", value: String(muscleId)))
            items.append(URLQueryItem(name: "status", value: "2"))
            return items

        case .exercisesByCategory(let categoryId, let language):
            var items = [URLQueryItem(name: "category", value: String(categoryId))]
            if let lang = language {
                items.append(URLQueryItem(name: "language", value: String(lang)))
            }
            return items

        case .exercisesByMuscle(let muscleId, let language):
            var items = [URLQueryItem(name: "muscles", value: String(muscleId))]
            if let lang = language {
                items.append(URLQueryItem(name: "language", value: String(lang)))
            }
            return items

        case .searchExercises(let query, let language):
            var items = [URLQueryItem(name: "term", value: query)]
            if let lang = language {
                items.append(URLQueryItem(name: "language", value: String(lang)))
            }
            return items

        default:
            return nil
        }
    }

    private func buildPaginationQuery(language: Int?, limit: Int?, offset: Int?) -> [URLQueryItem]? {
        var items: [URLQueryItem] = []
        if let lang = language {
            items.append(URLQueryItem(name: "language", value: String(lang)))
        }
        if let lim = limit {
            items.append(URLQueryItem(name: "limit", value: String(lim)))
        }
        if let off = offset {
            items.append(URLQueryItem(name: "offset", value: String(off)))
        }
        items.append(URLQueryItem(name: "format", value: "json"))
        return items.isEmpty ? nil : items
    }
}
