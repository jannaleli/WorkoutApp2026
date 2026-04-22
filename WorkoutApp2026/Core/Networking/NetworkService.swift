//
//  NetworkService.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

// MARK: - Protocol
protocol NetworkServiceProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T
}

// MARK: - Implementation
final class NetworkService: NetworkServiceProtocol, @unchecked Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try endpoint.buildRequest()

        #if DEBUG
        print("[NetworkService] Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        #endif

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        #if DEBUG
        print("[NetworkService] Response: \(httpResponse.statusCode)")
        #endif

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 429:
            throw NetworkError.rateLimited
        case 500...599:
            throw NetworkError.serverError(message: "Server error: \(httpResponse.statusCode)")
        default:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("[NetworkService] Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[NetworkService] Response data: \(jsonString.prefix(500))")
            }
            #endif
            throw NetworkError.decodingError(error)
        }
    }

    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        try await request(endpoint)
    }
}
