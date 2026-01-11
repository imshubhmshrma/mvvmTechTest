//
//  NetworkProtocol.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//
import Foundation

protocol NetworkLayerProtocol{
   // func makeGetRequest(url: URL) async -> Result<Data,APIError>
    func makeGetRequest(url: URL) async throws -> Data
}
