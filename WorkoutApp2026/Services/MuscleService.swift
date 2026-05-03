//
//  MuscleService.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

// MARK: - Protocol
protocol MuscleServiceProtocol: Sendable {
    func getAllMuscles() async throws -> [SDMuscle]
    func getMuscle(id: Int) async throws -> SDMuscle?
    func getMusclesForGroup(_ group: MuscleGroupType) async throws -> [SDMuscle]
    func syncMuscles() async throws
}

// MARK: - Implementation
final class MuscleService: MuscleServiceProtocol, @unchecked Sendable {
    private let repository: MuscleRepositoryProtocol

    init(repository: MuscleRepositoryProtocol) {
        self.repository = repository
    }

    func getAllMuscles() async throws -> [SDMuscle] {
        let muscles = try await repository.getAllMuscles()

        // If empty, sync from API first
        if muscles.isEmpty {
            try await syncMuscles()
            return try await repository.getAllMuscles()
        }

        return muscles
    }

    func getMuscle(id: Int) async throws -> SDMuscle? {
        if let muscle = try await repository.getMuscle(id: id) {
            return muscle
        }

        // Try syncing and fetching again
        try await syncMuscles()
        return try await repository.getMuscle(id: id)
    }

    func getMusclesForGroup(_ group: MuscleGroupType) async throws -> [SDMuscle] {
        let allMuscles = try await getAllMuscles()
        let muscleIds = group.muscleIds
        return allMuscles.filter { muscleIds.contains($0.id) }
    }

    func syncMuscles() async throws {
        try await repository.syncMuscles()
    }
}
