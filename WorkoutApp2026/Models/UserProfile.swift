//
//  UserProfile.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-11.
//

import Foundation

struct UserProfile: Codable, Identifiable, Hashable {
    var id: Int { return userId }
    let userId: Int
    let username: String
    let email: String?
    let emailVerified: Bool
    let dateJoined: String
    let isStaff: Bool
    let isTrustworthy: Bool
    let gym: Int?
    let age: Int?
    let heightCm: Int?
    let gender: String?
    let weightKg: String?
    let ro: Bool

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case email
        case emailVerified = "email_verified"
        case dateJoined = "date_joined"
        case isStaff = "is_staff"
        case isTrustworthy = "is_trustworthy"
        case gym
        case age
        case heightCm = "height_cm"
        case gender
        case weightKg = "weight_kg"
        case ro
    }
}
