//
//  Ingredient.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct Ingredient: Codable, Identifiable, Hashable {
    let id: Int
    let uuid: String
    let name: String
    let commonName: String?
    let brand: String?
    let remoteId: String?
    let sourceName: String?
    let sourceUrl: String?
    let code: String?
    let created: String
    let lastUpdate: String
    let lastImported: String?
    let energy: Int
    let protein: String
    let carbohydrates: String
    let carbohydratesSugar: String?
    let fat: String
    let fatSaturated: String?
    let fiber: String?
    let sodium: String?
    let isVegan: Bool?
    let isVegetarian: Bool?
    let nutriscore: String?
    let weightUnits: [IngredientWeightUnit]
    let language: Int
    let license: Int?
    let licenseTitle: String?
    let licenseObjectUrl: String?
    let licenseAuthor: String?
    let licenseAuthorUrl: String?
    let licenseDerivativeSourceUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case name
        case commonName = "common_name"
        case brand
        case remoteId = "remote_id"
        case sourceName = "source_name"
        case sourceUrl = "source_url"
        case code
        case created
        case lastUpdate = "last_update"
        case lastImported = "last_imported"
        case energy
        case protein
        case carbohydrates
        case carbohydratesSugar = "carbohydrates_sugar"
        case fat
        case fatSaturated = "fat_saturated"
        case fiber
        case sodium
        case isVegan = "is_vegan"
        case isVegetarian = "is_vegetarian"
        case nutriscore
        case weightUnits = "weight_units"
        case language
        case license
        case licenseTitle = "license_title"
        case licenseObjectUrl = "license_object_url"
        case licenseAuthor = "license_author"
        case licenseAuthorUrl = "license_author_url"
        case licenseDerivativeSourceUrl = "license_derivative_source_url"
    }
}

struct IngredientWeightUnit: Codable, Identifiable, Hashable {
    let id: Int
    let amount: String
    let gramWeight: String
    let unit: WeightUnit

    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case gramWeight = "gram_weight"
        case unit
    }
}

struct WeightUnit: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
