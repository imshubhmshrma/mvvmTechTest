//
//  UserService.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import Foundation

class UserService: UserServiceProtocol{
    
    private var network: NetworkLayer
    
    init(network: NetworkLayer = NetworkLayer()){
        self.network = network
    }
    
    func getUsers() async -> Result<[User], APIError> {
        let resut = await self.network.makeGetRequest(url: Constants.apiURL)
        switch resut{
        case .success(let data):
            do{
                let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                return .success(decodedResponse.users)
            } catch {
                return .failure(APIError.decodingFailure)
            } 
        case .failure(let error):
            return .failure(error)
        }
    }
}
