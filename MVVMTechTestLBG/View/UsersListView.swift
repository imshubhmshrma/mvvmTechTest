//
//  UsersListView.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//
import SwiftUI


struct UsersListView: View{
    @ObservedObject var userVM = UserViewModel(service: UserService())
    var body: some View{
        NavigationStack{
            if userVM.isLoading == false {
                List(userVM.users,id: \.id) { user in
                    UserCellView(user: user)
                }
                .navigationTitle("Users")
            } else {
                ProgressView()
            }
        }.task {
            await userVM.loadUsers()
        }
    }
}
