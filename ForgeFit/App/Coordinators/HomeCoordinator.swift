//
//  HomeCoordinator.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 26/07/26.
//

import Foundation

enum HomeRoute: Hashable {
    case detail(String) // placeholder, cresce quando a Home tiver conteúdo real (Sprint 8)
}

@MainActor
@Observable
final class HomeCoordinator {
    var path: [HomeRoute] = []
}
