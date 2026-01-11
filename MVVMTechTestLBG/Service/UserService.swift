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
        do{
            let data = try await self.network.makeGetRequest(url: Constants.apiURL)
            do{
                let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                return .success(decodedResponse.users)
            } catch {
                return .failure(APIError.decodingFailure)
            }
        } catch(let error){
            return .failure(error as! APIError)
        } 
    }
    
}
