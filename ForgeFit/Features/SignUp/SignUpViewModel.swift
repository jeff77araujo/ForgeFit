//
//  SignUpViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 24/07/26.
//

import Foundation

@MainActor
@Observable
final class SignUpViewModel {
    
    var email = ""
    var password = ""
    var passwordConfirmation = ""
    var isLoading = false
    var errorMessage: String?
    var showSuccessAlert = false
    
    private let authService: AuthServiceProtocol
    private let onSignUpSuccess: (User) -> Void
    private var createdUser: User?
    
    init(authService: AuthServiceProtocol, onSignUpSuccess: @escaping (User) -> Void) {
        self.authService = authService
        self.onSignUpSuccess = onSignUpSuccess
    }
    
    func signUp() async {
        errorMessage = nil
        
        guard password == passwordConfirmation else {
            errorMessage = "As senhas precisam ser iguais."
            return
        }
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let user = try await authService.signUp(email: email, password: password)
            createdUser = user
            showSuccessAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func confirmSuccess() {
        guard let createdUser else { return }
        onSignUpSuccess(createdUser)
    }
}
