//
//  AuthServiceProtocol.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 24/07/26.
//

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User
    func signUp(email: String, password: String) async throws -> User
    func logout() async throws
}

struct User: Identifiable, Hashable {
    let id: String
    let email: String
}
