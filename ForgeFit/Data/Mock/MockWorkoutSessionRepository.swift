//
//  MockWorkoutSessionRepository.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

final class MockWorkoutSessionRepository: WorkoutSessionRepositoryProtocol {
    
    private var sessions: [String: WorkoutSession]
    
    init(seed: [WorkoutSession] = []) {
        sessions = Dictionary(uniqueKeysWithValues: seed.map { ($0.id, $0) })
    }
    
    func createSession(_ session: WorkoutSession) async throws {
        try await Task.sleep(for: .seconds(1))
        sessions[session.id] = session
    }
    
    func fetchSessions(userId: String) async throws -> [WorkoutSession] {
        try await Task.sleep(for: .milliseconds(500))
        return sessions.values
            .filter { $0.userId == userId }
            .sorted { $0.date > $1.date }
    }
    
    func updateSession(_ session: WorkoutSession) async throws {
        try await Task.sleep(for: .seconds(1))
        sessions[session.id] = session
    }
}
