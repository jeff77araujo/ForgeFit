//
//  WorkoutListView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import SwiftUI

struct WorkoutListView: View {
    
    @Environment(WorkoutCoordinator.self) private var coordinator
    @State private var viewModel: WorkoutListViewModel
    
    init(workoutRepository: WorkoutRepositoryProtocol, userId: String) {
        _viewModel = State(wrappedValue: WorkoutListViewModel(workoutRepository: workoutRepository, userId: userId))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.workouts.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .padding(FFSpacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
        .navigationTitle("Meus treinos")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    coordinator.goToCreateWorkout()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            await viewModel.loadWorkouts()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: FFSpacing.sm) {
            Text("Nenhum treino criado ainda")
                .font(FFTypography.headline)
                .foregroundStyle(FFColors.textPrimary)
            Text("Toque em + para criar seu primeiro treino")
                .font(FFTypography.caption)
                .foregroundStyle(FFColors.textSecondary)
        }
    }
    
    private var list: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                DisclosureGroup {
                    ForEach(workout.exercises) { exercise in
                        Text(exercise.name)
                            .font(FFTypography.body)
                            .foregroundStyle(FFColors.textSecondary)
                            .padding(.leading, FFSpacing.sm)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: FFSpacing.xxs) {
                        Text(workout.name)
                            .font(FFTypography.headline)
                        Text("\(workout.exercises.count) exercícios")
                            .font(FFTypography.caption)
                            .foregroundStyle(FFColors.textSecondary)
                    }
                }
                .listRowBackground(FFColors.surface)
                .listRowSeparator(.hidden)
                .swipeActions {
                    Button("Excluir", role: .destructive) {
                        Task { await viewModel.deleteWorkout(workout) }
                    }
                    Button("Editar") {
                        coordinator.goToEditWorkout(workout)
                    }
                    .tint(FFColors.accent)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview("Light - Vazio") {
    NavigationStack {
        WorkoutListView(workoutRepository: MockWorkoutRepository(), userId: "preview-user")
    }
    .environment(WorkoutCoordinator())
    .preferredColorScheme(.light)
}

#Preview("Dark - Com treinos") {
    NavigationStack {
        WorkoutListView(
            workoutRepository: MockWorkoutRepository(seed: [
                Workout(
                    id: "1",
                    userId: "preview-user",
                    name: "Treino A - Peito",
                    exercises: [
                        Exercise(
                            id: "e1",
                            name: "Supino reto",
                            sets: [PlannedSet(id: "s1", reps: 10, weightKg: 40)]
                        ),
                        Exercise(
                            id: "e2",
                            name: "Peck deck",
                            sets: [PlannedSet(id: "s2", reps: 12, weightKg: 30)]
                        )
                    ],
                    createdAt: Date()
                )
            ]),
            userId: "preview-user"
        )
    }
    .environment(WorkoutCoordinator())
    .preferredColorScheme(.dark)
}
