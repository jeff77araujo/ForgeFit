//
//  SignUpView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 24/07/26.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var viewModel: SignUpViewModel
    
    init(authService: AuthServiceProtocol, onSignUpSuccess: @escaping (User) -> Void) {
        _viewModel = State(wrappedValue: SignUpViewModel(
            authService: authService,
            onSignUpSuccess: onSignUpSuccess
        ))
    }
    
    var body: some View {
        VStack(spacing: FFSpacing.md) {
            Text("ForgeFit")
                .font(FFTypography.largeTitle)
                .foregroundStyle(FFColors.textPrimary)
            
            FFTextField(
                placeholder: "E-mail",
                text: $viewModel.email,
                showsClearButton: true
            )
            
            FFTextField(
                placeholder: "Senha",
                text: $viewModel.password,
                isSecure: true
            )
            
            FFTextField(
                placeholder: "Repita a Senha",
                text: $viewModel.passwordConfirmation,
                isSecure: true
            )
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(FFTypography.caption)
                    .foregroundStyle(FFColors.error)
            }
            
            FFButton(
                title: "Criar usuário",
                style: .primary,
                isLoading: viewModel.isLoading) {
                    Task { await viewModel.signUp() }
            }
        }
        .padding(FFSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
        .alert("Conta criada!", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") {
                viewModel.confirmSuccess()
            }
        } message: {
            Text("Sua conta foi criada com sucesso.")
        }
    }
}

#Preview("Light") {
    SignUpView(authService: MockAuthService()) { _ in }
        .environment(AppCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    SignUpView(authService: MockAuthService()) { _ in }
        .environment(AppCoordinator())
        .preferredColorScheme(.dark)
}
