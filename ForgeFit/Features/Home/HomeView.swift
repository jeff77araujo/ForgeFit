//
//  HomeView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel: HomeViewModel
    
    init(sessionRepository: WorkoutSessionRepositoryProtocol, userId: String) {
        _viewModel = State(wrappedValue: HomeViewModel(sessionRepository: sessionRepository, userId: userId))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.sessions.isEmpty {
                emptyState
            } else {
                history
            }
        }
        .padding(FFSpacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
        .navigationTitle("Histórico")
        .task {
            await viewModel.loadSessions()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: FFSpacing.sm) {
            Text("Nenhum treino registrado ainda")
                .font(FFTypography.headline)
                .foregroundStyle(FFColors.textPrimary)
            Text("Finalize um treino na aba Treinos para vê-lo aqui")
                .font(FFTypography.caption)
                .foregroundStyle(FFColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var history: some View {
        List {
            ForEach(viewModel.sessions) { session in
                VStack(alignment: .leading, spacing: FFSpacing.xxs) {
                    Text(session.workoutName)
                        .font(FFTypography.headline)
                    
                    Text(session.date.formatted(date: .abbreviated, time: .shortened))
                        .font(FFTypography.caption)
                        .foregroundStyle(FFColors.textSecondary)
                    
                    let totalSets = session.completedExercises
                        .reduce(0) { $0 + $1.completedSets.count }
                    
                    let doneSets = session.completedExercises
                        .reduce(0) { $0 + $1.completedSets.filter(\.isDone).count }
                    
                    Text("\(doneSets)/\(totalSets) séries concluídas")
                        .font(FFTypography.caption)
                        .foregroundStyle(FFColors.accent)
                }
                .listRowBackground(FFColors.surface)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview("Light - Vazio") {
    NavigationStack {
        HomeView(sessionRepository: MockWorkoutSessionRepository(), userId: "preview-user")
    }
    .preferredColorScheme(.light)
}

#Preview("Dark - Com histórico") {
    NavigationStack {
        HomeView(
            sessionRepository: MockWorkoutSessionRepository(seed: [
                WorkoutSession(
                    id: "1",
                    userId: "preview-user",
                    workoutId: "w1",
                    workoutName: "Treino A - Peito",
                    date: Date(),
                    completedExercises: [
                        CompletedExercise(
                            id: "e1",
                            exerciseName: "Supino reto",
                            completedSets: [
                                CompletedSet(id: "s1", reps: 10, weightKg: 40, isDone: true),
                                CompletedSet(id: "s2", reps: 10, weightKg: 40, isDone: false)
                            ])
                    ],
                    isFinished: true
                )
            ]),
            userId: "preview-user"
        )
    }
    .preferredColorScheme(.dark)
}
