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
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        NavigationStack(path: $coordinator.path) {
            Group {
                if isAuthenticated, let userId = authService.currentUser()?.id {
                    MainTabView(userRepository: userRepository, userId: userId)
                } else {
                    LoginView(authService: authService) { user in
                        isAuthenticated = true
                    }
                }
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
        .task {
            isAuthenticated = authService.currentUser() != nil
        }
    }
}
