//
//  UserProfile.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import Foundation

struct UserProfile: Identifiable, Hashable, Codable {
    let id: String // mesmo uid do Firebase Auth
    var name: String
    var photoURL: String?
    var birthDate: Date?
    var weightKg: Double?
    var heightCm: Double?
    var goal: WorkoutGoal?
}

enum WorkoutGoal: String, Codable, CaseIterable {
    case hypertrophy
    case weightLoss
    case endurance
    case generalFitness
    
    var displayName: String {
        switch self {
        case .hypertrophy: "Hipertrofia"
        case .weightLoss: "Emagrecimento"
        case .endurance: "Resistência"
        case .generalFitness: "Condicionamento geral"
        }
    }
}
