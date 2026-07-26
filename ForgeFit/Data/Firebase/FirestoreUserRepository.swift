//
//  FirestoreUserRepository.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import FirebaseFirestore

final class FirestoreUserRepository: UserRepositoryProtocol {
    
    private let db = Firestore.firestore()
    private let collectionName = "users"
    
    func createProfile(_ profile: UserProfile) async throws {
        try db.collection(collectionName)
            .document(profile.id)
            .setData(from: profile)
    }
    
    func fetchProfile(userId: String) async throws -> UserProfile? {
        let document = try await db.collection(collectionName)
            .document(userId)
            .getDocument()
        
        guard document.exists else { return nil }
        return try document.data(as: UserProfile.self)
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        try db.collection(collectionName)
            .document(profile.id)
            .setData(from: profile, merge: true)
    }
}
