//
//  ProfileViewModel.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 25/07/26.
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel {
    
    var profile: UserProfile?
    var isLoading = false
    var isSaving = false
    var errorMessage: String?
    var showSavedAlert = false
    
    private let userRepository: UserRepositoryProtocol
    private let userId: String
    
    init(userRepository: UserRepositoryProtocol, userId: String) {
        self.userRepository = userRepository
        self.userId = userId
    }
    
    func loadProfile() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            profile = try await userRepository.fetchProfile(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func save() async {
        guard let profile else { return }
        
        errorMessage = nil
        isSaving = true
        defer { isSaving = false }
        
        do {
            try await userRepository.updateProfile(profile)
            showSavedAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
