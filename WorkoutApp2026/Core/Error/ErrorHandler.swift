//
//  ErrorHandler.swift
//  WorkoutApp2026
//
//  Created by Jann Aleli Zaplan on 2026-04-21.
//

import SwiftUI

@Observable
final class ErrorHandler {
    var currentError: AppError?
    var showError: Bool = false

    func handle(_ error: Error) {
        if let appError = error as? AppError {
            currentError = appError
        } else if let networkError = error as? NetworkError {
            currentError = .network(networkError)
        } else {
            currentError = .unknown(error)
        }
        showError = true

        // Log error for debugging
        #if DEBUG
        print("[ErrorHandler] \(currentError?.localizedDescription ?? "Unknown error")")
        #endif
    }

    func dismiss() {
        showError = false
        currentError = nil
    }
}

// MARK: - SwiftUI Error Alert Modifier
struct ErrorAlertModifier: ViewModifier {
    @Bindable var errorHandler: ErrorHandler

    func body(content: Content) -> some View {
        content
            .alert(
                "Error",
                isPresented: $errorHandler.showError,
                presenting: errorHandler.currentError
            ) { _ in
                Button("OK") {
                    errorHandler.dismiss()
                }
            } message: { error in
                VStack {
                    Text(error.localizedDescription)
                    if let recovery = error.recoverySuggestion {
                        Text(recovery)
                            .font(.caption)
                    }
                }
            }
    }
}

extension View {
    func handleErrors(with handler: ErrorHandler) -> some View {
        modifier(ErrorAlertModifier(errorHandler: handler))
    }
}
