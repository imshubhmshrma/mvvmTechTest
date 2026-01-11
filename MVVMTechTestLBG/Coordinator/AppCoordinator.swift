//
//  AppCoordinator.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 10/01/26.
//

//View → ViewModel → Coordinator → Navigation
import SwiftUI
import Combine

final class AppCoordinator: ObservableObject{
    @Published var path = NavigationPath()
    
    func showUsers(){
        path.append(AppRoute.UserList)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    func reset() {
        path = NavigationPath()
    }
    func showUserDetail(user: User) {
          path.append(AppRoute.UserDetail(user: user))
      }

}
