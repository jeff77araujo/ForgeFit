//
//  MockAuthService.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 24/07/26.
//

import SwiftUI

final class MockAuthService: AuthServiceProtocol {
    
    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .seconds(1)) // simula latência de rede
        
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        
        return User(id: UUID().uuidString, email: email)
    }
    
    func signUp(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .seconds(1))
        
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        
        return User(id: UUID().uuidString, email: email)
    }
    
    func logout() async throws {
        try await Task.sleep(for: .milliseconds(300))
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "E-mail ou senha inválidos"
        }
    }
}
