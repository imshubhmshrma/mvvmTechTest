//
//  UserCellView.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import SwiftUI

struct UserCellView: View{
    let user: User
    var body: some View{
        HStack{
            AsyncImage(url: URL(string: user.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } placeholder: {
                ProgressView()
            }
            Text(user.firstName + " " + user.lastName)
                .font(.title)
        }
    }
}
