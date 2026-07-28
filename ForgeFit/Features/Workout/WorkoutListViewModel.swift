//
//  WorkoutListViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import Foundation

@MainActor
@Observable
final class WorkoutListViewModel {
    
    var workouts: [Workout] = []
    var isLoading = false
    var errorMessage: String?
    
    private let workoutRepository: WorkoutRepositoryProtocol
    private let userId: String
    
    init(workoutRepository: WorkoutRepositoryProtocol, userId: String) {
        self.workoutRepository = workoutRepository
        self.userId = userId
    }
    
    func loadWorkouts() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            workouts = try await workoutRepository.fetchWorkouts(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteWorkout(_ workout: Workout) async {
        do {
            try await workoutRepository.deleteWorkout(id: workout.id)
            workouts.removeAll { $0.id == workout.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
