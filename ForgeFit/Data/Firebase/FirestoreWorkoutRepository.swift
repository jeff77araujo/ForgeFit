//
//  FirestoreWorkoutRepository.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import FirebaseFirestore

final class FirestoreWorkoutRepository: WorkoutRepositoryProtocol {
    
    private let db = Firestore.firestore()
    private let collectionName = "workouts"
    
    func createWorkout(_ workout: Workout) async throws {
        try db.collection(collectionName)
            .document(workout.id)
            .setData(from: workout)
    }
    
    func fetchWorkouts(userId: String) async throws -> [Workout] {
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: Workout.self)
        }
    }
    
    func updateWorkout(_ workout: Workout) async throws {
        try db.collection(collectionName)
            .document(workout.id)
            .setData(from: workout, merge: true)
    }
    
    func deleteWorkout(id: String) async throws {
        try await db.collection(collectionName)
            .document(id)
            .delete()
    }
}
