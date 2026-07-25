//
//  LoginView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 24/07/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AppCoordinator.self)
    private var coordinator
    
    @State private var viewModel: LoginViewModel
    
    init(authService: AuthServiceProtocol, onLoginSuccess: @escaping (User) -> Void) {
        _viewModel = State(wrappedValue: LoginViewModel(
            authService: authService,
            onLoginSuccess: onLoginSuccess
        ))
    }
    
    var body: some View {
        VStack(spacing: FFSpacing.md) {
            Text("ForgeFit")
                .font(FFTypography.largeTitle)
                .foregroundStyle(FFColors.textPrimary)
            
            FFTextField(placeholder: "E-mail", text: $viewModel.email, showsClearButton: true)
            FFTextField(placeholder: "Senha", text: $viewModel.password, isSecure: true)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(FFTypography.caption)
                    .foregroundStyle(FFColors.error)
            }
            
            FFButton(title: "Entrar", style: .primary, isLoading: viewModel.isLoading) {
                Task { await viewModel.login() }
            }
            
            Button("Ainda não tem conta? Criar conta") {
                coordinator.goToSignUp()
            }
            .font(FFTypography.caption)
            .foregroundStyle(FFColors.accent)
            
            Button("Esqueceu a senha?") {
                coordinator.goToForgotPassword()
            }
            .font(FFTypography.caption)
            .foregroundStyle(FFColors.textSecondary)
        }
        .padding(FFSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
    }
}

#Preview("Light") {
    LoginView(authService: MockAuthService()) { _ in }
        .environment(AppCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    LoginView(authService: MockAuthService()) { _ in }
        .environment(AppCoordinator())
        .preferredColorScheme(.dark)
}
