//
//  ApiError.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//

enum APIError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingFailure
    case networkFailure
}
