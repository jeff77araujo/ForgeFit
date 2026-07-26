//
//  MainTabView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 26/07/26.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var homeCoordinator = HomeCoordinator()
    @State private var profileCoordinator = ProfileCoordinator()
    @State private var workoutCoordinator = WorkoutCoordinator()
    
    let userRepository: UserRepositoryProtocol
    let userId: String
    
    var body: some View {
        TabView {
            homeTab
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            profileTab
                .tabItem { Label("Perfil", systemImage: "person.fill") }
            
            workoutTab
                .tabItem { Label("Treinos", systemImage: "dumbbell.fill") }
        }
        .tint(FFColors.accent)
    }
    
    private var homeTab: some View {
        @Bindable var homeCoordinator = homeCoordinator
        
        return NavigationStack(path: $homeCoordinator.path) {
            Text("Home") // placeholder até existir HomeView de verdade
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .detail(let id):
                        Text("Detalhe: \(id)")
                    }
                }
        }
        .environment(homeCoordinator)
    }
    
    private var profileTab: some View {
        @Bindable var profileCoordinator = profileCoordinator
        
        return NavigationStack(path: $profileCoordinator.path) {
            ProfileView(userRepository: userRepository, userId: userId)
                .navigationDestination(for: ProfileRoute.self) { route in
                    switch route {
                    case .editPhoto:
                        Text("Editar foto") // placeholder futuro
                    }
                }
        }
        .environment(profileCoordinator)
    }
    
    private var workoutTab: some View {
        @Bindable var workoutCoordinator = workoutCoordinator
        
        return NavigationStack(path: $workoutCoordinator.path) {
            Text("Treinos") // placeholder até a Sprint 5
                .navigationDestination(for: WorkoutRoute.self) { route in
                    switch route {
                    case .detail(let id):
                        Text("Detalhe do treino: \(id)")
                    }
                }
        }
        .environment(workoutCoordinator)
    }
}
