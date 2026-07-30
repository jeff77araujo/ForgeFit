//
//  WorkoutSession.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

import Foundation

struct WorkoutSession: Identifiable, Hashable, Codable {
    let id: String
    var userId: String
    var workoutId: String
    var workoutName: String
    var date: Date
    var completedExercises: [CompletedExercise]
    var isFinished: Bool
}

struct CompletedExercise: Identifiable, Hashable, Codable {
    let id: String
    var exerciseName: String
    var completedSets: [CompletedSet]
}

struct CompletedSet: Identifiable, Hashable, Codable {
    let id: String
    var reps: Int
    var weightKg: Double?
    var isDone: Bool
}
