//
//  UsersListView.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//
import SwiftUI


struct UsersListView: View{
    @StateObject var userVM : UserViewModel
    var body: some View{
        NavigationStack{
            if userVM.isLoading == false {
                List(userVM.users,id: \.id) { user in
                    UserCellView(user: user)
                        .onTapGesture {
                            print("User Tap on \(user.firstName)")
                            userVM.didSelectUser(user: user)
                        }
                }
                .accessibilityIdentifier("UsersListView")
                .navigationTitle("Users")
            } else {
                ProgressView()
                    .accessibilityIdentifier("UsersLoadingView") 
            }
        }.task {
            await userVM.loadUsers()
        }
    }
}
