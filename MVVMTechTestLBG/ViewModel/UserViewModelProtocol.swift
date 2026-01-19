//
//  UserViewModelProtocol.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 12/01/26.
//

import Foundation

protocol UserViewModelProtocol: ObservableObject{
    var users: [User] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadUsers() async
    func didSelectUser(user: User)
}
