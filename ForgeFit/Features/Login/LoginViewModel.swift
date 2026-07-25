//
//  LoginViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 24/07/26.
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    private let onLoginSuccess: (User) -> Void
    
    init(authService: AuthServiceProtocol, onLoginSuccess: @escaping (User) -> Void) {
        self.authService = authService
        self.onLoginSuccess = onLoginSuccess
    }
    
    func login() async {
        errorMessage = nil
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let user = try await authService.login(email: email, password: password)
            onLoginSuccess(user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
