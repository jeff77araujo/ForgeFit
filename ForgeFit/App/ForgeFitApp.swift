//
//  ForgeFitApp.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI
import FirebaseCore

@main
struct ForgeFitApp: App {
    
    @State private var coordinator = AppCoordinator()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(coordinator)
        }
    }
}
