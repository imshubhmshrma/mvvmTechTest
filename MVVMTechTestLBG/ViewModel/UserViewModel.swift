//
//  UserViewModel.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import SwiftUI
import Combine


class UserViewModel: ObservableObject{
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let service: UserService
    private let coordinator: AppCoordinator
    
    init(service: UserService,
         coordinator: AppCoordinator){
        self.service = service
        self.coordinator = coordinator
    }
    
    func loadUsers() async {
        self.isLoading = true
        self.errorMessage = nil
        defer{ self.isLoading = false }
        
        let result = await service.getUsers()
        switch result {
        case .success(let users):
            self.users = users
            self.isLoading = false
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func didSelectUser(user: User){
        coordinator.showUserDetail(user: user)
    }
}
