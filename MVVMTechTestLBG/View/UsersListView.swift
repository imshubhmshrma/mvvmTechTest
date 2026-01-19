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
                if  userVM.errorMessage == "networkFailure"{
                    NoInternetView()
                } else {
                    List(userVM.users,id: \.id) { user in
                        Button{
                            print("User Tap on \(user.firstName)")
                            userVM.didSelectUser(user: user)
                        } label: {
                            UserCellView(user: user)
                        }                }
                    .accessibilityIdentifier("UsersListView")
                    .navigationTitle("Users")
                }
            } else {
                ProgressView()
                    .accessibilityIdentifier("UsersLoadingView") 
            }
        }.task {
            await userVM.loadUsers()
        }
    }
     
}


struct NoInternetView: View{
    var body: some View{
        Text("Please check Internet Connection and try again")
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
            .foregroundColor(Color.red)
    }
}
