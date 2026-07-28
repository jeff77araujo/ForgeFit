//
//  MockWorkoutRepository.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

final class MockWorkoutRepository: WorkoutRepositoryProtocol {
    
    private var workouts: [String: Workout]
    
    init(seed: [Workout] = []) {
        workouts = Dictionary(uniqueKeysWithValues: seed.map { ($0.id, $0) })
    }
    
    func createWorkout(_ workout: Workout) async throws {
        try await Task.sleep(for: .seconds(1))
        workouts[workout.id] = workout
    }
    
    func fetchWorkouts(userId: String) async throws -> [Workout] {
        try await Task.sleep(for: .milliseconds(500))
        return workouts.values
            .filter { $0.userId == userId }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func updateWorkout(_ workout: Workout) async throws {
        try await Task.sleep(for: .seconds(1))
        workouts[workout.id] = workout
    }
    
    func deleteWorkout(id: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
        workouts[id] = nil
    }
}
