//
//  ForgotPasswordViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import Foundation

@MainActor
@Observable
final class ForgotPasswordViewModel {
    
    var email = ""
    var isLoading = false
    var errorMessage: String?
    var showSuccessAlert = false
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func resetPassword() async {
        errorMessage = nil
        
        guard !email.isEmpty else {
            errorMessage = "Digite seu e-mail."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authService.resetPassword(email: email)
            showSuccessAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
