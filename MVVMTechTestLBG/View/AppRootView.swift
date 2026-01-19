//
//  AppRootView.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 10/01/26.
//
import SwiftUI

struct AppRootView: View{
    
    @StateObject private var coordinator = AppCoordinator()
    var body: some View{
        NavigationStack(path: $coordinator.path){
            UsersListView(userVM: UserViewModel(service: UserService(), coordinator: coordinator))
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .environmentObject(coordinator)
    }
       @ViewBuilder
    private func destination(for route: AppRoute) -> some View{
        switch route{
        case .UserList:
            UsersListView(userVM: UserViewModel(service: UserService(), coordinator: coordinator))
        case .UserDetail(let user):
            UserDetailView(user: user)
        }
    }
}
