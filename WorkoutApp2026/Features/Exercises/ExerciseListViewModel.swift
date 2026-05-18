//
//  ExerciseListViewModel.swift
//  WorkoutApp2026
//
//  Created by Codex on 2026-05-03.
//

import Foundation

@MainActor
@Observable
final class ExerciseListViewModel {
    enum ExerciseFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case compound = "Compound"
        case isolation = "Isolation"
        case bodyweight = "Bodyweight"

        var id: String { rawValue }
    }

    struct SelectedExercise: Identifiable {
        let exercise: SDExercise
        var sets: Int = 3
        var reps: Int = 12

        var id: Int { exercise.id }
    }

    let muscleGroup: MuscleGroupType
    var exercises: [SDExercise] = []
    var searchText = ""
    var selectedFilter: ExerciseFilter = .all
    var selectedExercises: [Int: SelectedExercise] = [:]
    var expandedExerciseId: Int?
    var isLoading = false
    var isStartingWorkout = false
    var errorMessage: String?

    private let pageSize = 30
    private var exerciseService: ExerciseServiceProtocol?
    private var workoutService: WorkoutServiceProtocol?

    init(muscleGroup: MuscleGroupType) {
        self.muscleGroup = muscleGroup
    }

    func configure(exerciseService: ExerciseServiceProtocol, workoutService: WorkoutServiceProtocol) {
        self.exerciseService = exerciseService
        self.workoutService = workoutService
    }

    var filteredExercises: [SDExercise] {
        exercises.filter { exercise in
            matchesSearch(exercise) && matchesSelectedFilter(exercise)
        }
    }

    var selectedCount: Int {
        selectedExercises.count
    }

    var plannedSetCount: Int {
        selectedExercises.values.reduce(0) { $0 + $1.sets }
    }

    var metadataText: String {
        "\(muscleGroup.tag.uppercased()) - \(exercises.count) EXERCISES"
    }

    var emptyStateTitle: String {
        if !searchText.isEmpty || selectedFilter != .all {
            return "No matching exercises"
        }
        return "No exercises found"
    }

    var emptyStateMessage: String {
        if !searchText.isEmpty || selectedFilter != .all {
            return "Try a different search or filter."
        }
        return "Pull to refresh and try loading \(muscleGroup.displayName.lowercased()) again."
    }

    func loadExercises() async {
        guard !isLoading, exercises.isEmpty else { return }
        await refreshExercises()
    }

    func refreshExercises() async {
        guard let exerciseService else {
            errorMessage = "Exercise service is unavailable."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await exerciseService.getExercises(
                forMuscleGroup: muscleGroup,
                limit: pageSize,
                offset: 0
            )
            exercises = result.exercises.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func isSelected(_ exercise: SDExercise) -> Bool {
        selectedExercises[exercise.id] != nil
    }

    func selectedExercise(for exercise: SDExercise) -> SelectedExercise? {
        selectedExercises[exercise.id]
    }

    func toggleSelection(for exercise: SDExercise) {
        if selectedExercises[exercise.id] != nil {
            selectedExercises.removeValue(forKey: exercise.id)
            if expandedExerciseId == exercise.id {
                expandedExerciseId = nil
            }
        } else {
            selectedExercises[exercise.id] = SelectedExercise(exercise: exercise)
            expandedExerciseId = exercise.id
        }
    }

    func toggleExpanded(for exercise: SDExercise) {
        guard isSelected(exercise) else {
            toggleSelection(for: exercise)
            return
        }
        expandedExerciseId = expandedExerciseId == exercise.id ? nil : exercise.id
    }

    func incrementSets(for exercise: SDExercise) {
        updateSelection(for: exercise) { $0.sets = min($0.sets + 1, 10) }
    }

    func decrementSets(for exercise: SDExercise) {
        updateSelection(for: exercise) { $0.sets = max($0.sets - 1, 1) }
    }

    func incrementReps(for exercise: SDExercise) {
        updateSelection(for: exercise) { $0.reps = min($0.reps + 1, 50) }
    }

    func decrementReps(for exercise: SDExercise) {
        updateSelection(for: exercise) { $0.reps = max($0.reps - 1, 1) }
    }

    func startWorkout() async -> UUID? {
        guard !selectedExercises.isEmpty, let workoutService else { return nil }
        isStartingWorkout = true
        errorMessage = nil

        do {
            let session = try await workoutService.startNewSession(routine: nil)
            let selections = selectedExercises.values.sorted {
                $0.exercise.name.localizedCaseInsensitiveCompare($1.exercise.name) == .orderedAscending
            }

            for selection in selections {
                for _ in 0..<selection.sets {
                    _ = try await workoutService.addSet(
                        to: session,
                        exercise: selection.exercise,
                        reps: selection.reps,
                        weight: nil,
                        weightUnit: "kg"
                    )
                }
            }

            isStartingWorkout = false
            return session.id
        } catch {
            errorMessage = error.localizedDescription
            isStartingWorkout = false
            return nil
        }
    }

    private func updateSelection(for exercise: SDExercise, mutate: (inout SelectedExercise) -> Void) {
        guard var selection = selectedExercises[exercise.id] else { return }
        mutate(&selection)
        selectedExercises[exercise.id] = selection
    }

    private func matchesSearch(_ exercise: SDExercise) -> Bool {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return true }
        return exercise.name.localizedCaseInsensitiveContains(trimmed)
            || (exercise.categoryName?.localizedCaseInsensitiveContains(trimmed) ?? false)
    }

    private func matchesSelectedFilter(_ exercise: SDExercise) -> Bool {
        switch selectedFilter {
        case .all:
            return true
        case .compound:
            return containsAny(exercise, terms: ["press", "row", "squat", "deadlift", "lunge", "pull-up", "pull up", "push-up", "push up", "dip", "clean"])
        case .isolation:
            return containsAny(exercise, terms: ["fly", "curl", "extension", "raise", "calf", "crunch", "lateral", "reverse", "kickback"])
        case .bodyweight:
            return containsAny(exercise, terms: ["bodyweight", "push-up", "push up", "pull-up", "pull up", "squat", "plank", "crunch", "sit-up", "sit up", "dip"])
        }
    }

    private func containsAny(_ exercise: SDExercise, terms: [String]) -> Bool {
        let searchable = [
            exercise.name,
            exercise.categoryName ?? "",
            exercise.exerciseDescription ?? ""
        ]
            .joined(separator: " ")
            .lowercased()

        return terms.contains { searchable.contains($0) }
    }
}
