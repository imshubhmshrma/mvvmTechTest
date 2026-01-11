//
//  UserDetail.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 11/01/26.
//
import SwiftUI

struct UserDetailView: View{
    let user: User
    var body: some View{
        VStack{
            Spacer()
                .frame(height: 20)
            AsyncImage(url: URL(string: user.image)) { image in
                image
                   .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            Spacer()
                .frame(height: 20)
            HStack{
                Text("User Id : \(user.id)")
            }
            HStack{
                Text("First Name : \(user.firstName)")
            }
            HStack{
                Text("Last Name : \(user.lastName)")
            }
            Spacer()
        }.navigationTitle("User Details")
    }
}
