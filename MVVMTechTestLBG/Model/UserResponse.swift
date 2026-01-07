//
//  UserResponse.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//
//https://dummyjson.com/users

import Foundation

struct UserResponse: Decodable{
    var users: [User]
}
