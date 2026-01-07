//
//  User.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//

import Foundation

struct User: Decodable, Identifiable{
    let id: Int
    let firstName: String
    let lastName: String
    let image: String
}
