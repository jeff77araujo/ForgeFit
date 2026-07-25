//
//  FirebaseAuthService.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import FirebaseAuth

final class FirebaseAuthService: AuthServiceProtocol {
    
    func login(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return User(id: result.user.uid, email: result.user.email ?? email)
    }
    
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return User(id: result.user.uid, email: result.user.email ?? email)
    }
    
    func logout() async throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func currentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return User(id: firebaseUser.uid, email: firebaseUser.email ?? "")
    }
}
