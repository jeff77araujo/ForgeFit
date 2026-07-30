//
//  HomeViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

import Foundation

@MainActor
@Observable
final class HomeViewModel {
    
    var sessions: [WorkoutSession] = []
    var isLoading = false
    var errorMessage: String?
    
    private let sessionRepository: WorkoutSessionRepositoryProtocol
    private let userId: String
    
    init(sessionRepository: WorkoutSessionRepositoryProtocol, userId: String) {
        self.sessionRepository = sessionRepository
        self.userId = userId
    }
    
    func loadSessions() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            sessions = try await sessionRepository.fetchSessions(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
