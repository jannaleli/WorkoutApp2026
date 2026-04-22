//
//  ExerciseMapper.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

enum ExerciseMapper {

    // MARK: - ExerciseInfo -> SDExercise
    static func toSwiftData(from exerciseInfo: ExerciseInfo) -> SDExercise {
        // Get English translation (language ID 2)
        let englishTranslation = exerciseInfo.translations.first { $0.language == 2 }
        let name = englishTranslation?.name ?? exerciseInfo.translations.first?.name ?? "Unknown Exercise"
        let description = englishTranslation?.description ?? exerciseInfo.translations.first?.description

        return SDExercise(
            id: exerciseInfo.id,
            uuid: exerciseInfo.uuid,
            name: name,
            description: description,
            categoryId: exerciseInfo.category.id,
            categoryName: exerciseInfo.category.name,
            muscleIds: exerciseInfo.muscles.map { $0.id },
            muscleSecondaryIds: exerciseInfo.musclesSecondary.map { $0.id },
            equipmentIds: exerciseInfo.equipment.map { $0.id },
            imageURLs: exerciseInfo.images.filter { $0.isMain }.map { $0.image } +
                       exerciseInfo.images.filter { !$0.isMain }.map { $0.image },
            videoURLs: exerciseInfo.videos.map { $0.video }
        )
    }

    // MARK: - Exercise -> SDExercise (basic version without full details)
    static func toSwiftData(from exercise: Exercise) -> SDExercise {
        SDExercise(
            id: exercise.id,
            uuid: exercise.uuid,
            name: "",  // Needs translation lookup separately
            categoryId: exercise.category,
            muscleIds: exercise.muscles,
            muscleSecondaryIds: exercise.musclesSecondary,
            equipmentIds: exercise.equipment
        )
    }

    // MARK: - Update existing SDExercise from ExerciseInfo
    static func update(_ sdExercise: SDExercise, from exerciseInfo: ExerciseInfo) {
        let englishTranslation = exerciseInfo.translations.first { $0.language == 2 }

        sdExercise.name = englishTranslation?.name ?? exerciseInfo.translations.first?.name ?? sdExercise.name
        sdExercise.exerciseDescription = englishTranslation?.description ?? exerciseInfo.translations.first?.description
        sdExercise.categoryId = exerciseInfo.category.id
        sdExercise.categoryName = exerciseInfo.category.name
        sdExercise.muscleIds = exerciseInfo.muscles.map { $0.id }
        sdExercise.muscleSecondaryIds = exerciseInfo.musclesSecondary.map { $0.id }
        sdExercise.equipmentIds = exerciseInfo.equipment.map { $0.id }
        sdExercise.imageURLs = exerciseInfo.images.filter { $0.isMain }.map { $0.image } +
                              exerciseInfo.images.filter { !$0.isMain }.map { $0.image }
        sdExercise.videoURLs = exerciseInfo.videos.map { $0.video }
        sdExercise.lastUpdated = Date()
    }

    // MARK: - Batch Mapping
    static func toSwiftData(from exerciseInfoList: [ExerciseInfo]) -> [SDExercise] {
        exerciseInfoList.map { toSwiftData(from: $0) }
    }
}
