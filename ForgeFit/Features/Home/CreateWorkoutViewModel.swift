//
//  CreateWorkoutViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import Foundation

@MainActor
@Observable
final class CreateWorkoutViewModel {
    
    var name: String
    var exercises: [Exercise]
    var isSaving = false
    var errorMessage: String?
    var didSave = false
    
    private let workoutRepository: WorkoutRepositoryProtocol
    private let userId: String
    private let existingWorkout: Workout?
    
    var isEditing: Bool { existingWorkout != nil }
    
    init(workoutRepository: WorkoutRepositoryProtocol, userId: String, editing workout: Workout? = nil) {
        self.workoutRepository = workoutRepository
        self.userId = userId
        self.existingWorkout = workout
        self.name = workout?.name ?? ""
        self.exercises = workout?.exercises ?? []
    }
    
    func addExercise() {
        exercises.append(
            Exercise(id: UUID().uuidString, name: "", sets: [
                PlannedSet(id: UUID().uuidString, reps: 10, weightKg: nil)
            ])
        )
    }
    
    func removeExercise(id: String) {
        exercises.removeAll { $0.id == id }
    }
    
    func addSet(toExercise exerciseId: String) {
        guard let index = exercises.firstIndex(where: { $0.id == exerciseId }) else { return }
        exercises[index].sets.append(PlannedSet(id: UUID().uuidString, reps: 10, weightKg: nil))
    }
    
    func save() async {
        errorMessage = nil
        
        guard !name.isEmpty else {
            errorMessage = "Digite um nome para o treino."
            return
        }
        guard !exercises.isEmpty else {
            errorMessage = "Adicione pelo menos um exercício."
            return
        }
        
        isSaving = true
        defer { isSaving = false }
        
        let workout = Workout(
            id: existingWorkout?.id ?? UUID().uuidString,
            userId: userId,
            name: name,
            exercises: exercises,
            createdAt: existingWorkout?.createdAt ?? Date()
        )
        
        do {
            if isEditing {
                try await workoutRepository.updateWorkout(workout)
            } else {
                try await workoutRepository.createWorkout(workout)
            }
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
