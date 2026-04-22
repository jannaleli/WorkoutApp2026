//
//  Injectable.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import Foundation

/// Property wrapper for dependency injection from the shared container
@propertyWrapper
struct Injected<T> {
    private let keyPath: KeyPath<DIContainer, T>

    init(_ keyPath: KeyPath<DIContainer, T>) {
        self.keyPath = keyPath
    }

    var wrappedValue: T {
        DIContainer.shared[keyPath: keyPath]
    }
}

/// Property wrapper for optional dependencies
@propertyWrapper
struct InjectedOptional<T> {
    private let keyPath: KeyPath<DIContainer, T?>

    init(_ keyPath: KeyPath<DIContainer, T?>) {
        self.keyPath = keyPath
    }

    var wrappedValue: T? {
        DIContainer.shared[keyPath: keyPath]
    }
}
