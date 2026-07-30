//
//  WorkoutSessionViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

import Foundation

@MainActor
@Observable
final class WorkoutSessionViewModel {
    
    var session: WorkoutSession
    var isSaving = false
    var errorMessage: String?
    var didFinish = false
    
    private let sessionRepository: WorkoutSessionRepositoryProtocol
    
    init(workout: Workout, userId: String, sessionRepository: WorkoutSessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
        self.session = WorkoutSession(
            id: UUID().uuidString,
            userId: userId,
            workoutId: workout.id,
            workoutName: workout.name,
            date: Date(),
            completedExercises: workout.exercises.map { exercise in
                CompletedExercise(
                    id: UUID().uuidString,
                    exerciseName: exercise.name,
                    completedSets: exercise.sets.map { set in
                        CompletedSet(
                            id: UUID().uuidString,
                            reps: set.reps,
                            weightKg: set.weightKg,
                            isDone: false
                        )
                    }
                )
            },
            isFinished: false
        )
    }
    
    func toggleSetDone(exerciseId: String, setId: String) {
        guard let exerciseIndex = session.completedExercises.firstIndex(where: {
            $0.id == exerciseId
        }),
              let setIndex = session.completedExercises[exerciseIndex].completedSets.firstIndex(where: {
                  $0.id == setId
              })
        else { return }
        
        session.completedExercises[exerciseIndex].completedSets[setIndex].isDone.toggle()
    }
    
    func finish() async {
        errorMessage = nil
        isSaving = true
        defer { isSaving = false }
        
        session.isFinished = true
        
        do {
            try await sessionRepository.createSession(session)
            didFinish = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
