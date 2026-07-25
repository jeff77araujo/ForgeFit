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
}
