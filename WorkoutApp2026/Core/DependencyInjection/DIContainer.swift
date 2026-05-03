//
//  DIContainer.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class DIContainer {
    static let shared = DIContainer()

    // MARK: - Core Dependencies
    private(set) var modelContainer: ModelContainer!
    private(set) var networkService: NetworkServiceProtocol!
    private(set) var errorHandler: ErrorHandler!
    private(set) var appCoordinator: AppCoordinator!

    // MARK: - Services
    private(set) var exerciseService: ExerciseServiceProtocol!
    private(set) var muscleService: MuscleServiceProtocol!
    private(set) var workoutService: WorkoutServiceProtocol!

    // MARK: - Repositories
    private(set) var exerciseRepository: ExerciseRepositoryProtocol!
    private(set) var muscleRepository: MuscleRepositoryProtocol!
    private(set) var workoutRepository: WorkoutRepositoryProtocol!

    private init() {}

    func configure() {
        configureModelContainer()
        configureErrorHandling()
        configureNetworking()
        configureNavigation()
        // Note: Repositories and Services will be configured after their implementations are created
    }

    private func configureModelContainer() {
        let schema = Schema([
            SDExercise.self,
            SDMuscle.self,
            SDMuscleGroup.self,
            SDRoutine.self,
            SDWorkoutSession.self,
            SDWorkoutLog.self,
            SDUserProfile.self,
            SDCacheMetadata.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    private func configureErrorHandling() {
        errorHandler = ErrorHandler()
    }

    private func configureNetworking() {
        networkService = NetworkService()
    }

    private func configureNavigation() {
        appCoordinator = AppCoordinator()
    }

    // MARK: - Configure Repositories (call after all dependencies are ready)
    func configureRepositories() {
        let context = modelContainer.mainContext
        exerciseRepository = ExerciseRepository(modelContext: context, networkService: networkService)
        muscleRepository = MuscleRepository(modelContext: context, networkService: networkService)
        workoutRepository = WorkoutRepository(modelContext: context)
    }

    // MARK: - Configure Services (call after repositories are ready)
    func configureServices() {
        exerciseService = ExerciseService(repository: exerciseRepository)
        muscleService = MuscleService(repository: muscleRepository)
        workoutService = WorkoutService(repository: workoutRepository)
    }
}

// MARK: - Environment Key
struct DIContainerKey: EnvironmentKey {
    static let defaultValue = DIContainer.shared
}

extension EnvironmentValues {
    var container: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
