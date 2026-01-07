//
//  MockURLProtocol.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//

import Foundation

final class MockURLProtocol: URLProtocol{
    static var mockData: Data?
    static var mockResponse: HTTPURLResponse?
    static var mockError: Error?
    
    static func mockStubs(data: Data?,
                   response:HTTPURLResponse?,
                   error:Error?){
        MockURLProtocol.mockData = data
        MockURLProtocol.mockResponse = response
        MockURLProtocol.mockError = error
    }
    
    static func clearStubs(){
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let validError = MockURLProtocol.mockError{
            client?.urlProtocol(self, didFailWithError: validError)
            return
        } else if let data = MockURLProtocol.mockData{
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response =  MockURLProtocol.mockResponse{
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
