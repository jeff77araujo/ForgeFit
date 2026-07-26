//
//  UserRepositoryProtocol.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

protocol UserRepositoryProtocol {
    func createProfile(_ profile: UserProfile) async throws
    func fetchProfile(userId: String) async throws -> UserProfile?
    func updateProfile(_ profile: UserProfile) async throws
}
