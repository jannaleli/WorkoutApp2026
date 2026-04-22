//
//  AppError.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

enum AppError: Error, LocalizedError, Identifiable {
    var id: String { localizedDescription }

    case network(NetworkError)
    case persistence(Error)
    case validation(String)
    case sync(String)
    case notFound(String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .persistence(let error):
            return "Database error: \(error.localizedDescription)"
        case .validation(let message):
            return message
        case .sync(let message):
            return "Sync failed: \(message)"
        case .notFound(let item):
            return "\(item) not found"
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .network(.noConnection):
            return "Check your internet connection and try again."
        case .network(.timeout):
            return "The server is taking too long. Please try again."
        case .network(.unauthorized):
            return "Please log in again."
        case .persistence:
            return "Try restarting the app."
        case .sync:
            return "Pull down to refresh and try again."
        default:
            return "Please try again later."
        }
    }
}
