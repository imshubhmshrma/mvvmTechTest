//
//  NetworkLayer.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//
import Foundation

class NetworkLayer: NetworkLayerProtocol{
    
    private(set) var session: URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
//    func makeGetRequestt(url: URL) async -> Result<Data, APIError> {
//        do{
//            let (data, response) = try await session.data(from: url)
//            
//            guard let response = response as! HTTPURLResponse?  else {
//                return .failure(.invalidResponse)
//            }
//            switch response.statusCode {
//            case 200...299:
//                return .success(data)
//            case 300...499:
//                return .failure(.invalidStatusCode)
//            case 500...599:
//               return .failure(.serverError)
//            default:
//                return .failure(.invalidResponse)
//            }
//        }catch {
//            return .failure(.networkFailure)
//        }
//    }
     
    func makeGetRequest(url: URL) async throws -> Data{
        do{
            let (data,response) = try await  self.session.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }
            switch response.statusCode {
            case 200...299:
                return data
            case 300...499:
                throw (APIError.invalidStatusCode)
            case 500...599:
                throw (APIError.serverError)
            default:
                throw (APIError.invalidResponse)
            } 
        }catch let error as APIError {
            throw error
        } catch{
            throw APIError.networkFailure
        }
    }
}
