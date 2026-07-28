//
//  WorkoutRepositoryProtocol.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

protocol WorkoutRepositoryProtocol {
    func createWorkout(_ workout: Workout) async throws
    func fetchWorkouts(userId: String) async throws -> [Workout]
    func updateWorkout(_ workout: Workout) async throws
    func deleteWorkout(id: String) async throws
}
