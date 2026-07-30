//
//  WorkoutSessionRepositoryProtocol.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 29/07/26.
//

protocol WorkoutSessionRepositoryProtocol {
    func createSession(_ session: WorkoutSession) async throws
    func fetchSessions(userId: String) async throws -> [WorkoutSession]
    func updateSession(_ session: WorkoutSession) async throws
}
