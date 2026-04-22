//
//  MuscleRepository.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

// MARK: - Protocol
protocol MuscleRepositoryProtocol: Sendable {
    func getAllMuscles() async throws -> [SDMuscle]
    func getMuscle(id: Int) async throws -> SDMuscle?
    func fetchMusclesFromAPI() async throws -> [SDMuscle]
    func cacheMuscles(_ muscles: [SDMuscle]) async throws
    func syncMuscles() async throws
}

// MARK: - Implementation
final class MuscleRepository: MuscleRepositoryProtocol, @unchecked Sendable {
    private let modelContext: ModelContext
    private let networkService: NetworkServiceProtocol

    init(modelContext: ModelContext, networkService: NetworkServiceProtocol) {
        self.modelContext = modelContext
        self.networkService = networkService
    }

    // MARK: - Local Operations

    func getAllMuscles() async throws -> [SDMuscle] {
        let descriptor = FetchDescriptor<SDMuscle>(
            sortBy: [SortDescriptor(\.nameEn)]
        )
        return try modelContext.fetch(descriptor)
    }

    func getMuscle(id: Int) async throws -> SDMuscle? {
        let descriptor = FetchDescriptor<SDMuscle>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }

    // MARK: - API Operations

    func fetchMusclesFromAPI() async throws -> [SDMuscle] {
        let endpoint = WgerEndpoint.muscles
        let response: PaginatedResponse<Muscle> = try await networkService.request(endpoint)
        return MuscleMapper.toSwiftData(from: response.results)
    }

    // MARK: - Cache Storage

    func cacheMuscles(_ muscles: [SDMuscle]) async throws {
        for muscle in muscles {
            let existingDescriptor = FetchDescriptor<SDMuscle>(
                predicate: #Predicate { $0.id == muscle.id }
            )

            if let existing = try modelContext.fetch(existingDescriptor).first {
                existing.name = muscle.name
                existing.nameEn = muscle.nameEn
                existing.isFront = muscle.isFront
                existing.imageUrlMain = muscle.imageUrlMain
                existing.imageUrlSecondary = muscle.imageUrlSecondary
            } else {
                modelContext.insert(muscle)
            }
        }

        // Update cache metadata
        let cacheDescriptor = FetchDescriptor<SDCacheMetadata>(
            predicate: #Predicate { $0.key == SDCacheMetadata.musclesKey }
        )

        if let existingMetadata = try modelContext.fetch(cacheDescriptor).first {
            existingMetadata.refresh(ttlMinutes: 1440, itemCount: muscles.count) // 24 hour cache
        } else {
            let metadata = SDCacheMetadata(key: SDCacheMetadata.musclesKey, ttlMinutes: 1440, itemCount: muscles.count)
            modelContext.insert(metadata)
        }

        try modelContext.save()
    }

    // MARK: - Sync

    func syncMuscles() async throws {
        // Check cache validity
        let cacheDescriptor = FetchDescriptor<SDCacheMetadata>(
            predicate: #Predicate { $0.key == SDCacheMetadata.musclesKey }
        )

        if let metadata = try modelContext.fetch(cacheDescriptor).first, metadata.isValid {
            // Cache is still valid, skip sync
            return
        }

        // Fetch and cache
        let muscles = try await fetchMusclesFromAPI()
        try await cacheMuscles(muscles)
    }
}
