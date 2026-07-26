//
//  MockUserRepository.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

final class MockUserRepository: UserRepositoryProtocol {
    
    private var profiles: [String: UserProfile]
    
    init(seed: [UserProfile] = []) {
        profiles = Dictionary(uniqueKeysWithValues: seed.map { ($0.id, $0) })
    }
    
    func createProfile(_ profile: UserProfile) async throws {
        try await Task.sleep(for: .seconds(1))
        profiles[profile.id] = profile
    }
    
    func fetchProfile(userId: String) async throws -> UserProfile? {
        try await Task.sleep(for: .milliseconds(500))
        return profiles[userId]
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        try await Task.sleep(for: .seconds(1))
        profiles[profile.id] = profile
    }
}
