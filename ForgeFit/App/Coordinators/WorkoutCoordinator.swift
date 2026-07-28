//
//  WorkoutCoordinator.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 26/07/26.
//

import Foundation

enum WorkoutRoute: Hashable {
    case createWorkout
    case editWorkout(Workout)
}

@MainActor
@Observable
final class WorkoutCoordinator {
    var path: [WorkoutRoute] = []
    
    func goToCreateWorkout() {
        path.append(.createWorkout)
    }
    
    func goToEditWorkout(_ workout: Workout) {
        path.append(.editWorkout(workout))
    }
}
