//
//  SDMuscle.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation
import SwiftData

@Model
final class SDMuscle {
    @Attribute(.unique) var id: Int
    var name: String
    var nameEn: String
    var isFront: Bool
    var imageUrlMain: String?
    var imageUrlSecondary: String?

    init(
        id: Int,
        name: String,
        nameEn: String,
        isFront: Bool,
        imageUrlMain: String? = nil,
        imageUrlSecondary: String? = nil
    ) {
        self.id = id
        self.name = name
        self.nameEn = nameEn
        self.isFront = isFront
        self.imageUrlMain = imageUrlMain
        self.imageUrlSecondary = imageUrlSecondary
    }

    var mainImageURL: URL? {
        guard let urlString = imageUrlMain else { return nil }
        return URL(string: urlString)
    }

    var secondaryImageURL: URL? {
        guard let urlString = imageUrlSecondary else { return nil }
        return URL(string: urlString)
    }
}
