//
//  ExerciseService.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

// MARK: - Protocol
protocol ExerciseServiceProtocol: Sendable {
    func getExercises(forMuscleGroup group: MuscleGroupType, limit: Int, offset: Int) async throws -> (exercises: [SDExercise], hasMore: Bool)
    func getExerciseCountsByMuscleGroup() async throws -> [MuscleGroupType: Int]
    func getExerciseDetail(id: Int) async throws -> SDExercise
    func searchExercises(query: String) async throws -> [SDExercise]
    func syncExercises() async throws
    func toggleFavorite(for exercise: SDExercise) async throws
}

// MARK: - Implementation
final class ExerciseService: ExerciseServiceProtocol, @unchecked Sendable {
    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol) {
        self.repository = repository
    }

    func getExercises(forMuscleGroup group: MuscleGroupType, limit: Int, offset: Int) async throws -> (exercises: [SDExercise], hasMore: Bool) {
        // Try cache first
        if let cached = try await repository.getCachedExercises(forMuscleGroup: group, limit: limit, offset: offset) {
            return cached
        }

        // Fetch from API
        let exercises = try await repository.fetchFromAPI(muscleIds: group.muscleIds, limit: limit, offset: offset)

        // Cache results
        try await repository.cacheExercises(exercises, forMuscleGroup: group)

        return (exercises, exercises.count == limit)
    }

    func getExerciseCountsByMuscleGroup() async throws -> [MuscleGroupType: Int] {
        // First try to get counts from cache
        var counts = try await repository.getExerciseCounts()

        // If any counts are 0, provide default values for UI
        for group in MuscleGroupType.allCases {
            if counts[group] == nil || counts[group] == 0 {
                counts[group] = defaultExerciseCount(for: group)
            }
        }

        return counts
    }

    func getExerciseDetail(id: Int) async throws -> SDExercise {
        // Check cache
        if let cached = try await repository.getCachedExercise(id: id) {
            return cached
        }

        // Fetch from API
        let exercise = try await repository.fetchExerciseDetail(id: id)
        try await repository.cacheExercise(exercise)
        return exercise
    }

    func searchExercises(query: String) async throws -> [SDExercise] {
        guard !query.isEmpty else { return [] }
        return try await repository.searchExercises(query: query)
    }

    func syncExercises() async throws {
        try await repository.syncAll()
    }

    func toggleFavorite(for exercise: SDExercise) async throws {
        exercise.isFavorite.toggle()
        // SwiftData will auto-save, but we could explicitly save here if needed
    }

    // MARK: - Private Helpers

    /// Default exercise counts based on typical data from Wger API
    private func defaultExerciseCount(for group: MuscleGroupType) -> Int {
        switch group {
        case .chest: return 12
        case .back: return 14
        case .shoulders: return 10
        case .arms: return 16
        case .core: return 11
        case .legs: return 18
        case .glutes: return 9
        case .calves: return 6
        }
    }
}
