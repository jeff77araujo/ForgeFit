//
//  ForgeFitApp.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI

@main
struct ForgeFitApp: App {

    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(coordinator)
        }
    }
}
