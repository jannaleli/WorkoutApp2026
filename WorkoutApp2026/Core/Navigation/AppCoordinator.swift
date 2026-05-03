//
//  AppCoordinator.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

// MARK: - App Coordinator
@Observable
final class AppCoordinator {
    var selectedTab: AppTab = .home
    var homePath = NavigationPath()
    var historyPath = NavigationPath()
    var buildPath = NavigationPath()
    var profilePath = NavigationPath()

    // MARK: - Navigation Actions

    func navigate(to route: Route) {
        switch selectedTab {
        case .home:
            homePath.append(route)
        case .history:
            historyPath.append(route)
        case .build:
            buildPath.append(route)
        case .profile:
            profilePath.append(route)
        }
    }

    func pop() {
        switch selectedTab {
        case .home:
            guard !homePath.isEmpty else { return }
            homePath.removeLast()
        case .history:
            guard !historyPath.isEmpty else { return }
            historyPath.removeLast()
        case .build:
            guard !buildPath.isEmpty else { return }
            buildPath.removeLast()
        case .profile:
            guard !profilePath.isEmpty else { return }
            profilePath.removeLast()
        }
    }

    func popToRoot() {
        switch selectedTab {
        case .home:
            homePath = NavigationPath()
        case .history:
            historyPath = NavigationPath()
        case .build:
            buildPath = NavigationPath()
        case .profile:
            profilePath = NavigationPath()
        }
    }

    func switchTab(to tab: AppTab) {
        if selectedTab == tab {
            // If already on this tab, pop to root
            popToRoot()
        } else {
            selectedTab = tab
        }
    }

    // MARK: - Path Binding for current tab

    var currentPath: Binding<NavigationPath> {
        switch selectedTab {
        case .home:
            return Binding(
                get: { self.homePath },
                set: { self.homePath = $0 }
            )
        case .history:
            return Binding(
                get: { self.historyPath },
                set: { self.historyPath = $0 }
            )
        case .build:
            return Binding(
                get: { self.buildPath },
                set: { self.buildPath = $0 }
            )
        case .profile:
            return Binding(
                get: { self.profilePath },
                set: { self.profilePath = $0 }
            )
        }
    }
}

// MARK: - Environment Key
struct AppCoordinatorKey: EnvironmentKey {
    static let defaultValue: AppCoordinator? = nil
}

extension EnvironmentValues {
    var appCoordinator: AppCoordinator? {
        get { self[AppCoordinatorKey.self] }
        set { self[AppCoordinatorKey.self] = newValue }
    }
}
