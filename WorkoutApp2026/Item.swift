//
//  Item.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-05.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
