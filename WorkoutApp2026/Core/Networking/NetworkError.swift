//
//  NetworkError.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case noConnection
    case timeout
    case unauthorized
    case serverError(message: String)
    case rateLimited

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(let statusCode, _):
            return "HTTP Error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let message):
            return message
        case .rateLimited:
            return "Too many requests. Please wait and try again."
        }
    }
}
