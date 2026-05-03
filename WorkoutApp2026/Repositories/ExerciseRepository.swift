//
//  ExerciseRepository.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

// MARK: - Protocol
protocol ExerciseRepositoryProtocol: Sendable {
    func getCachedExercises(forMuscleGroup group: MuscleGroupType, limit: Int, offset: Int) async throws -> (exercises: [SDExercise], hasMore: Bool)?
    func fetchFromAPI(muscleIds: [Int], limit: Int, offset: Int) async throws -> [SDExercise]
    func cacheExercises(_ exercises: [SDExercise], forMuscleGroup group: MuscleGroupType) async throws
    func getCachedExercise(id: Int) async throws -> SDExercise?
    func fetchExerciseDetail(id: Int) async throws -> SDExercise
    func cacheExercise(_ exercise: SDExercise) async throws
    func getExerciseCounts() async throws -> [MuscleGroupType: Int]
    func searchExercises(query: String) async throws -> [SDExercise]
    func syncAll() async throws
}

// MARK: - Implementation
final class ExerciseRepository: ExerciseRepositoryProtocol, @unchecked Sendable {
    private let modelContext: ModelContext
    private let networkService: NetworkServiceProtocol

    init(modelContext: ModelContext, networkService: NetworkServiceProtocol) {
        self.modelContext = modelContext
        self.networkService = networkService
    }

    // MARK: - Cache Operations

    func getCachedExercises(forMuscleGroup group: MuscleGroupType, limit: Int, offset: Int) async throws -> (exercises: [SDExercise], hasMore: Bool)? {
        // Check if cache is valid
        let cacheKey = SDCacheMetadata.key(for: group)
        let searchKey = cacheKey
        let cacheDescriptor = FetchDescriptor<SDCacheMetadata>(
            predicate: #Predicate { $0.key == searchKey }
        )

        guard let metadata = try modelContext.fetch(cacheDescriptor).first,
              metadata.isValid else {
            return nil
        }

        // Fetch exercises from SwiftData
        let muscleIds = group.muscleIds
        var descriptor = FetchDescriptor<SDExercise>(
            sortBy: [SortDescriptor(\.name)]
        )
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset

        let allExercises = try modelContext.fetch(descriptor)

        // Filter by muscle IDs (SwiftData doesn't support array contains in predicates well)
        let filtered = allExercises.filter { exercise in
            exercise.muscleIds.contains { muscleIds.contains($0) }
        }

        let hasMore = filtered.count == limit
        return (Array(filtered.prefix(limit)), hasMore)
    }

    func getCachedExercise(id: Int) async throws -> SDExercise? {
        let searchId = id
        let descriptor = FetchDescriptor<SDExercise>(
            predicate: #Predicate { $0.id == searchId }
        )
        return try modelContext.fetch(descriptor).first
    }

    // MARK: - API Operations

    func fetchFromAPI(muscleIds: [Int], limit: Int, offset: Int) async throws -> [SDExercise] {
        var allExercises: [SDExercise] = []

        for muscleId in muscleIds {
            let endpoint = WgerEndpoint.exerciseInfoList(language: 2, limit: limit, offset: offset)
            let response: PaginatedResponse<ExerciseInfo> = try await networkService.request(endpoint)

            // Filter by muscle ID and map to SwiftData models
            let filtered = response.results.filter { exerciseInfo in
                exerciseInfo.muscles.contains { $0.id == muscleId }
            }

            let exercises = ExerciseMapper.toSwiftData(from: filtered)
            allExercises.append(contentsOf: exercises)
        }

        // Remove duplicates based on ID
        let uniqueExercises = Dictionary(grouping: allExercises, by: { $0.id })
            .compactMapValues { $0.first }
            .values

        return Array(uniqueExercises)
    }

    func fetchExerciseDetail(id: Int) async throws -> SDExercise {
        let endpoint = WgerEndpoint.exerciseInfo(id: id)
        let exerciseInfo: ExerciseInfo = try await networkService.request(endpoint)
        return ExerciseMapper.toSwiftData(from: exerciseInfo)
    }

    // MARK: - Cache Storage

    func cacheExercises(_ exercises: [SDExercise], forMuscleGroup group: MuscleGroupType) async throws {
        for exercise in exercises {
            // Check if exercise already exists
            let exerciseId = exercise.id
            let existingDescriptor = FetchDescriptor<SDExercise>(
                predicate: #Predicate { $0.id == exerciseId }
            )

            if let existing = try modelContext.fetch(existingDescriptor).first {
                // Update existing
                existing.name = exercise.name
                existing.exerciseDescription = exercise.exerciseDescription
                existing.categoryId = exercise.categoryId
                existing.categoryName = exercise.categoryName
                existing.muscleIds = exercise.muscleIds
                existing.muscleSecondaryIds = exercise.muscleSecondaryIds
                existing.equipmentIds = exercise.equipmentIds
                existing.imageURLs = exercise.imageURLs
                existing.videoURLs = exercise.videoURLs
                existing.lastUpdated = Date()
            } else {
                modelContext.insert(exercise)
            }
        }

        // Update cache metadata
        let cacheKey = SDCacheMetadata.key(for: group)
        let searchCacheKey = cacheKey
        let cacheDescriptor = FetchDescriptor<SDCacheMetadata>(
            predicate: #Predicate { $0.key == searchCacheKey }
        )

        if let existingMetadata = try modelContext.fetch(cacheDescriptor).first {
            existingMetadata.refresh(ttlMinutes: 60, itemCount: exercises.count)
        } else {
            let metadata = SDCacheMetadata(key: cacheKey, ttlMinutes: 60, itemCount: exercises.count)
            modelContext.insert(metadata)
        }

        try modelContext.save()
    }

    func cacheExercise(_ exercise: SDExercise) async throws {
        let exerciseId = exercise.id
        let existingDescriptor = FetchDescriptor<SDExercise>(
            predicate: #Predicate { $0.id == exerciseId }
        )

        if try modelContext.fetch(existingDescriptor).first == nil {
            modelContext.insert(exercise)
            try modelContext.save()
        }
    }

    // MARK: - Counts

    func getExerciseCounts() async throws -> [MuscleGroupType: Int] {
        var counts: [MuscleGroupType: Int] = [:]

        // First try to get from cache metadata
        for group in MuscleGroupType.allCases {
            let cacheKey = SDCacheMetadata.key(for: group)
            let searchKey = cacheKey
            let cacheDescriptor = FetchDescriptor<SDCacheMetadata>(
                predicate: #Predicate { $0.key == searchKey }
            )

            if let metadata = try modelContext.fetch(cacheDescriptor).first {
                counts[group] = metadata.itemCount
            } else {
                // Fallback: count exercises in SwiftData
                let muscleIds = group.muscleIds
                let allExercises = try modelContext.fetch(FetchDescriptor<SDExercise>())
                let filtered = allExercises.filter { exercise in
                    exercise.muscleIds.contains { muscleIds.contains($0) }
                }
                counts[group] = filtered.count
            }
        }

        return counts
    }

    // MARK: - Search

    func searchExercises(query: String) async throws -> [SDExercise] {
        let lowercasedQuery = query.lowercased()
        let descriptor = FetchDescriptor<SDExercise>(
            sortBy: [SortDescriptor(\.name)]
        )

        let allExercises = try modelContext.fetch(descriptor)
        return allExercises.filter { $0.name.lowercased().contains(lowercasedQuery) }
    }

    // MARK: - Full Sync

    func syncAll() async throws {
        let endpoint = WgerEndpoint.exerciseInfoList(language: 2, limit: 100, offset: 0)
        let response: PaginatedResponse<ExerciseInfo> = try await networkService.request(endpoint)

        for exerciseInfo in response.results {
            let sdExercise = ExerciseMapper.toSwiftData(from: exerciseInfo)
            let exerciseId = sdExercise.id

            let existingDescriptor = FetchDescriptor<SDExercise>(
                predicate: #Predicate { $0.id == exerciseId }
            )

            if let existing = try modelContext.fetch(existingDescriptor).first {
                ExerciseMapper.update(existing, from: exerciseInfo)
            } else {
                modelContext.insert(sdExercise)
            }
        }

        try modelContext.save()
    }
}
