//
//  AppCoordinator.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI
import Observation

enum AppRoute: Hashable {
    case signUp
    case forgotPassword
}

@MainActor
@Observable
final class AppCoordinator {
    
    var path: [AppRoute] = []
    
    func goToSignUp() {
        path.append(.signUp)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func goToForgotPassword() {
        path.append(.forgotPassword)
    }
}
