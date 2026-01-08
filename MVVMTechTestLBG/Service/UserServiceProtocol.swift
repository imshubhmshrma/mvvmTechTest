//
//  ServiceProtocol.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

protocol UserServiceProtocol{
    func getUsers() async -> Result<[User],APIError>
}
