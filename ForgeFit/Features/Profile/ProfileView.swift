//
//  ProfileView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var viewModel: ProfileViewModel
    
    init(userRepository: UserRepositoryProtocol, userId: String) {
        _viewModel = State(
            wrappedValue: ProfileViewModel(
                userRepository: userRepository,
                userId: userId
            )
        )
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.profile == nil {
                Text(errorMessage)
                    .foregroundStyle(FFColors.error)
            } else if viewModel.profile == nil {
                Text("Perfil não encontrado.")
                    .foregroundStyle(FFColors.textSecondary)
            } else {
                form
            }
        }
        .padding(FFSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
        .task {
            await viewModel.loadProfile()
        }
        .alert("Perfil salvo!", isPresented: $viewModel.showSavedAlert) {
            Button("OK") {}
        }
    }
    
    @ViewBuilder
    private var form: some View {
        if let profile = Binding($viewModel.profile) {
            ScrollView {
                VStack(spacing: FFSpacing.md) {
                    FFTextField(
                        placeholder: "Nome",
                        text: profile.name,
                        showsClearButton: true
                    )
                    
                    Picker("Meta de treino", selection: profile.goal) {
                        Text("Não definida").tag(WorkoutGoal?.none)
                        ForEach(WorkoutGoal.allCases, id: \.self) { goal in
                            Text(goal.displayName).tag(WorkoutGoal?.some(goal))
                        }
                    }
                    .pickerStyle(.menu)
                    
                    DatePicker(
                        "Data de nascimento",
                        selection: Binding(
                            get: { profile.wrappedValue.birthDate ?? Date() },
                            set: { profile.wrappedValue.birthDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    
                    HStack {
                        FFTextField(
                            placeholder: "Peso (kg)",
                            text: Binding(
                                get: {
                                    profile.wrappedValue.weightKg
                                        .map { String($0) } ?? ""
                                },
                                set: {
                                    profile.wrappedValue.weightKg = Double($0)
                                }
                            )
                        )
                        
                        FFTextField(
                            placeholder: "Altura (cm)",
                            text: Binding(
                                get: {
                                    profile.wrappedValue.heightCm
                                        .map { String($0) } ?? ""
                                },
                                set: {
                                    profile.wrappedValue.heightCm = Double($0)
                                }
                            )
                        )
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(FFTypography.caption)
                            .foregroundStyle(FFColors.error)
                    }
                    
                    FFButton(
                        title: "Salvar",
                        style: .primary,
                        isLoading: viewModel.isSaving
                    ) {
                        Task { await viewModel.save() }
                    }
                }
            }
        }
    }
}

#Preview("Light") {
    ProfileView(
        userRepository: MockUserRepository(
            seed: [
                UserProfile(
                    id: "preview-user",
                    name: "Jeff Araujo",
                    goal: .hypertrophy
                )
            ]
        ),
        userId: "preview-user"
    )
    .environment(ProfileCoordinator())
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    ProfileView(
        userRepository: MockUserRepository(
            seed: [
                UserProfile(
                    id: "preview-user",
                    name: "Jeff Araujo",
                    goal: .hypertrophy
                )
            ]
        ),
        userId: "preview-user"
    )
    .environment(ProfileCoordinator())
    .preferredColorScheme(.dark)
}
