//
//  UserService.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import Foundation

class UserService: UserServiceProtocol{
    
    private(set) var network: NetworkLayer
    
    init(network: NetworkLayer = NetworkLayer()){
        self.network = network
    }
    
    func getUsers() async throws -> [User] {
        do{
            let data = try await self.network.makeGetRequest(url: Constants.apiURL)
            do{
                let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                return decodedResponse.users
            } catch {
                throw APIError.decodingFailure
            }
        } catch(let error){
            throw error
        }
    }
    
}
