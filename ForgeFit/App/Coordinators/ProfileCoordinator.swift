//
//  ProfileCoordinator.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 26/07/26.
//

import Foundation

enum ProfileRoute: Hashable {
    case editPhoto
}

@MainActor
@Observable
final class ProfileCoordinator {
    var path: [ProfileRoute] = []
}
