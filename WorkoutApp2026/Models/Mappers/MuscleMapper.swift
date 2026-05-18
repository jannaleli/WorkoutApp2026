//
//  MuscleMapper.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

enum MuscleMapper {

    // MARK: - Muscle (API) -> SDMuscle
    static func toSwiftData(from muscle: Muscle) -> SDMuscle {
        SDMuscle(
            id: muscle.id,
            name: muscle.name,
            nameEn: muscle.nameEn ?? muscle.name,
            isFront: muscle.isFront,
            imageUrlMain: muscle.imageUrlMain,
            imageUrlSecondary: muscle.imageUrlSecondary
        )
    }

    // MARK: - Update existing SDMuscle
    static func update(_ sdMuscle: SDMuscle, from muscle: Muscle) {
        sdMuscle.name = muscle.name
        sdMuscle.nameEn = muscle.nameEn ?? muscle.name
        sdMuscle.isFront = muscle.isFront
        sdMuscle.imageUrlMain = muscle.imageUrlMain
        sdMuscle.imageUrlSecondary = muscle.imageUrlSecondary
    }

    // MARK: - Batch Mapping
    static func toSwiftData(from muscles: [Muscle]) -> [SDMuscle] {
        muscles.map { toSwiftData(from: $0) }
    }

    // MARK: - Muscle ID to MuscleGroupType mapping
    static func muscleGroupType(for muscleId: Int) -> MuscleGroupType? {
        for groupType in MuscleGroupType.allCases {
            if groupType.muscleIds.contains(muscleId) {
                return groupType
            }
        }
        return nil
    }

    // MARK: - Get all muscle IDs for a muscle group
    static func muscleIds(for groupType: MuscleGroupType) -> [Int] {
        groupType.muscleIds
    }
}
