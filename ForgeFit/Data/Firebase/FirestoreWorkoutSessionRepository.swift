//
//  FirestoreWorkoutSessionRepository.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

import FirebaseFirestore

final class FirestoreWorkoutSessionRepository: WorkoutSessionRepositoryProtocol {
    
    private let db = Firestore.firestore()
    private let collectionName = "workoutSessions"
    
    func createSession(_ session: WorkoutSession) async throws {
        try db.collection(collectionName)
            .document(session.id)
            .setData(from: session)
    }
    
    func fetchSessions(userId: String) async throws -> [WorkoutSession] {
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: WorkoutSession.self) }
    }
    
    func updateSession(_ session: WorkoutSession) async throws {
        try db.collection(collectionName)
            .document(session.id)
            .setData(from: session, merge: true)
    }
}
