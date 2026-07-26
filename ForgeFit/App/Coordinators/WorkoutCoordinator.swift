//
//  WorkoutCoordinator.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 26/07/26.
//

import Foundation

enum WorkoutRoute: Hashable {
    case detail(String)
}

@MainActor
@Observable
final class WorkoutCoordinator {
    var path: [WorkoutRoute] = []
}
