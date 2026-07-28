//
//  Exercise.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import Foundation

struct Exercise: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    var sets: [PlannedSet]
}

struct PlannedSet: Identifiable, Hashable, Codable {
    let id: String
    var reps: Int
    var weightKg: Double?
}
