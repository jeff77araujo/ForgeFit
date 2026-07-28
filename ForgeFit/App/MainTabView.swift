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
    let workoutRepository: WorkoutRepositoryProtocol
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
            HomeView()
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .detail(let id):
                        Text("Detalhe: \(id)")
                    }
                }
        }
        .environment(homeCoordinator)
    }
    
    private var workoutTab: some View {
        @Bindable var workoutCoordinator = workoutCoordinator
        
        return NavigationStack(path: $workoutCoordinator.path) {
            WorkoutListView(workoutRepository: workoutRepository, userId: userId)
                .navigationDestination(for: WorkoutRoute.self) { route in
                    switch route {
                    case .createWorkout:
                        CreateWorkoutView(workoutRepository: workoutRepository, userId: userId)
                    case .editWorkout(let workout):
                        CreateWorkoutView(workoutRepository: workoutRepository, userId: userId, editing: workout)
                    }
                }
        }
        .environment(workoutCoordinator)
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
}
