//
//  WorkoutSessionView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

import SwiftUI

struct WorkoutSessionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: WorkoutSessionViewModel
    
    init(workout: Workout, userId: String, sessionRepository: WorkoutSessionRepositoryProtocol) {
        _viewModel = State(wrappedValue: WorkoutSessionViewModel(
            workout: workout,
            userId: userId,
            sessionRepository: sessionRepository
        ))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.session.completedExercises) { exercise in
                Section(exercise.exerciseName) {
                    ForEach(exercise.completedSets) { set in
                        HStack {
                            Button {
                                viewModel.toggleSetDone(exerciseId: exercise.id, setId: set.id)
                            } label: {
                                Image(systemName: set.isDone
                                      ? "checkmark.circle.fill"
                                      : "circle"
                                )
                                .foregroundStyle(set.isDone
                                                 ? FFColors.success
                                                 : FFColors.textSecondary
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Text("\(set.reps) reps")
                            Spacer()
                            if let weightKg = set.weightKg {
                                Text("\(weightKg, specifier: "%.1f") kg")
                                    .foregroundStyle(FFColors.textSecondary)
                            }
                        }
                    }
                }
                .listRowBackground(FFColors.surface)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(FFColors.background)
        .navigationTitle(viewModel.session.workoutName)
        .safeAreaInset(edge: .bottom) {
            FFButton(
                title: "Finalizar treino",
                style: .primary,
                isLoading: viewModel.isSaving
            ) {
                Task { await viewModel.finish() }
            }
            .padding(FFSpacing.md)
            .background(FFColors.background)
        }
        .onChange(of: viewModel.didFinish) { _, didFinish in
            if didFinish { dismiss() }
        }
    }
}

#Preview("Light") {
    NavigationStack {
        WorkoutSessionView(
            workout: Workout(
                id: "1",
                userId: "preview-user",
                name: "Treino A - Peito",
                exercises: [
                    Exercise(
                        id: "e1",
                        name: "Supino reto",
                        sets: [
                            PlannedSet(id: "s1", reps: 10, weightKg: 40),
                            PlannedSet(id: "s2", reps: 10, weightKg: 40)
                        ])
                ],
                createdAt: Date()
            ),
            userId: "preview-user",
            sessionRepository: MockWorkoutSessionRepository()
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        WorkoutSessionView(
            workout: Workout(
                id: "1",
                userId: "preview-user",
                name: "Treino A - Peito",
                exercises: [
                    Exercise(
                        id: "e1",
                        name: "Supino reto",
                        sets: [
                            PlannedSet(id: "s1", reps: 10, weightKg: 40)
                        ])
                ],
                createdAt: Date()
            ),
            userId: "preview-user",
            sessionRepository: MockWorkoutSessionRepository()
        )
    }
    .preferredColorScheme(.dark)
}
