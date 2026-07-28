//
//  CreateWorkoutView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import SwiftUI

struct CreateWorkoutView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CreateWorkoutViewModel
    
    init(workoutRepository: WorkoutRepositoryProtocol, userId: String, editing workout: Workout? = nil) {
        _viewModel = State(wrappedValue: CreateWorkoutViewModel(
            workoutRepository: workoutRepository,
            userId: userId,
            editing: workout
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: FFSpacing.md) {
                FFTextField(placeholder: "Nome do treino", text: $viewModel.name, showsClearButton: true)
                
                ForEach($viewModel.exercises) { $exercise in
                    exerciseCard(exercise: $exercise)
                }
                
                FFButton(title: "Adicionar exercício", style: .secondary) {
                    viewModel.addExercise()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(FFTypography.caption)
                        .foregroundStyle(FFColors.error)
                }
                
                FFButton(
                    title: viewModel.isEditing ? "Salvar alterações" : "Criar treino",
                    style: .primary,
                    isLoading: viewModel.isSaving
                ) {
                    Task { await viewModel.save() }
                }
            }
            .padding(FFSpacing.lg)
        }
        .background(FFColors.background)
        .navigationTitle(viewModel.isEditing ? "Editar treino" : "Novo treino")
        .onChange(of: viewModel.didSave) { _, didSave in
            if didSave { dismiss() }
        }
    }
    
    @ViewBuilder
    private func exerciseCard(exercise: Binding<Exercise>) -> some View {
        FFCard {
            VStack(spacing: FFSpacing.sm) {
                FFTextField(placeholder: "Nome do exercício", text: exercise.name, showsClearButton: true)
                
                ForEach(exercise.sets) { $set in
                    HStack {
                        Stepper("Reps: \(set.reps)", value: $set.reps, in: 1...50)
                        
                        FFTextField(
                            placeholder: "Kg",
                            text: Binding(
                                get: { set.weightKg.map { String($0) } ?? "" },
                                set: { set.weightKg = Double($0) }
                            )
                        )
                        .frame(width: 80)
                    }
                }
                
                Button("Adicionar série") {
                    viewModel.addSet(toExercise: exercise.wrappedValue.id)
                }
                .font(FFTypography.caption)
                .foregroundStyle(FFColors.accent)
                
                Button("Remover exercício", role: .destructive) {
                    viewModel.removeExercise(id: exercise.wrappedValue.id)
                }
                .font(FFTypography.caption)
            }
        }
    }
}

#Preview("Light - Criar") {
    NavigationStack {
        CreateWorkoutView(workoutRepository: MockWorkoutRepository(), userId: "preview-user")
    }
    .preferredColorScheme(.light)
}

#Preview("Dark - Editar") {
    NavigationStack {
        CreateWorkoutView(
            workoutRepository: MockWorkoutRepository(),
            userId: "preview-user",
            editing: Workout(
                id: "1",
                userId: "preview-user",
                name: "Treino A - Peito",
                exercises: [
                    Exercise(
                        id: "e1",
                        name: "Supino reto",
                        sets: [
                            PlannedSet(
                                id: "s1",
                                reps: 10,
                                weightKg: 40
                            )
                        ])
                ],
                createdAt: Date()
            )
        )
    }
    .preferredColorScheme(.dark)
}
