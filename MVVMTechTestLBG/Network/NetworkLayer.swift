//
//  NetworkLayer.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//
import Foundation

class NetworkLayer: NetworkLayerProtocol{
    
    var session: URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func makeGetRequest(url: URL) async -> Result<Data, APIError> {
        do{
            let (data, response) = try await session.data(from: url)
            
            guard let response = response as! HTTPURLResponse?, (200...299).contains(response.statusCode) else {
                return .failure(.invalidResponse)
            } 
            return .success(data)
        }catch {
            return .failure(.networkFailure)
        }
    }
}
