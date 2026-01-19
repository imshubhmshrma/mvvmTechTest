//
//  UserViewModel.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import SwiftUI
import Combine
/*
 ViewModel = single source of truth
 View = observer + event sender
*/

//Network->service->viewmodel->coordination->view

class UserViewModel: UserViewModelProtocol{
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
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
        do{
            let result = try await service.getUsers()
            self.users = result
            self.isLoading = false
        }catch(let error){
            self.errorMessage = "\(error)"
            self.isLoading = false
        }
    }
    
    func didSelectUser(user: User){
        coordinator.showUserDetail(user: user)
    }
}
