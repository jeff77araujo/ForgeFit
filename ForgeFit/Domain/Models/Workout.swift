//
//  Workout.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import Foundation

struct Workout: Identifiable, Hashable, Codable {
    let id: String
    var userId: String
    var name: String
    var exercises: [Exercise]
    var createdAt: Date
}
