//
//  ForgotPasswordView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ForgotPasswordViewModel
    
    init(authService: AuthServiceProtocol) {
        _viewModel = State(wrappedValue: ForgotPasswordViewModel(authService: authService))
    }
    
    var body: some View {
        VStack(spacing: FFSpacing.md) {
            Text("Recuperar senha")
                .font(FFTypography.largeTitle)
                .foregroundStyle(FFColors.textPrimary)
            
            Text("Digite seu e-mail e enviaremos um link para redefinir sua senha.")
                .font(FFTypography.body)
                .foregroundStyle(FFColors.textSecondary)
                .multilineTextAlignment(.center)
            
            FFTextField(placeholder: "E-mail", text: $viewModel.email, showsClearButton: true)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(FFTypography.caption)
                    .foregroundStyle(FFColors.error)
            }
            
            FFButton(title: "Enviar link", style: .primary, isLoading: viewModel.isLoading) {
                Task { await viewModel.resetPassword() }
            }
        }
        .padding(FFSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
        .alert("E-mail enviado!", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Verifique sua caixa de entrada para redefinir sua senha.")
        }
    }
}
