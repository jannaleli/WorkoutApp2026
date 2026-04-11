//
//  Gallery.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct GalleryImage: Codable, Identifiable, Hashable {
    let id: Int
    let date: String
    let image: String
    let height: Int
    let width: Int
    let description: String?
}
