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
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        NavigationStack(path: $coordinator.path) {
            Group {
                if isAuthenticated {
                    homePlaceholder
                } else {
                    LoginView(authService: authService) { user in
                        isAuthenticated = true
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .login: Text("Login")
                case .home: Text("Home")
                case .profile: Text("Profile")
                case .workout: Text("Workout")
                case .signUp:
                    SignUpView(authService: authService) { user in
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
    
    private var homePlaceholder: some View {
        VStack(spacing: FFSpacing.md) {
            Text("Home")
                .font(FFTypography.largeTitle)
                .foregroundStyle(FFColors.textPrimary)
            
            FFButton(title: "Sair", style: .secondary) {
                Task {
                    try? await authService.logout()
                    isAuthenticated = false
                }
            }
        }
        .padding(FFSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
    }
}
