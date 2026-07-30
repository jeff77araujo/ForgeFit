//
//  RootView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI

struct RootView: View {
    
    @Environment(AppCoordinator.self)
    private var coordinator
    
    @State private var isAuthenticated = false
    private let authService: AuthServiceProtocol = FirebaseAuthService()
    private let userRepository: UserRepositoryProtocol = FirestoreUserRepository()
    private let workoutRepository: WorkoutRepositoryProtocol = FirestoreWorkoutRepository()
    private let sessionRepository: WorkoutSessionRepositoryProtocol = FirestoreWorkoutSessionRepository()
    
    var body: some View {
        Group {
            if isAuthenticated, let userId = authService.currentUser()?.id {
                MainTabView(
                    userRepository: userRepository,
                    workoutRepository: workoutRepository,
                    sessionRepository: sessionRepository,
                    userId: userId
                )
            } else {
                authFlow
            }
        }
        .task {
            isAuthenticated = authService.currentUser() != nil
        }
    }
    
    private var authFlow: some View {
        @Bindable var coordinator = coordinator
        
        return NavigationStack(path: $coordinator.path) {
            LoginView(authService: authService) { user in
                isAuthenticated = true
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .signUp:
                    SignUpView(authService: authService, userRepository: userRepository) { user in
                        coordinator.popToRoot()
                        isAuthenticated = true
                    }
                case .forgotPassword:
                    ForgotPasswordView(authService: authService)
                }
            }
        }
    }
}
