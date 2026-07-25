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
    private let authService: AuthServiceProtocol = MockAuthService()
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        NavigationStack(path: $coordinator.path) {
            Group {
                if isAuthenticated {
                    Text("Home") // placeholder
                } else {
                    LoginView(authService: authService) { user in
                        isAuthenticated = true
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .signUp:
                    SignUpView(authService: authService) { user in
                        isAuthenticated = true
                    }
                case .login: Text("Login")
                case .home: Text("Home")
                case .profile: Text("Profile")
                case .workout: Text("Workout")
                }
            }
        }
    }
}
