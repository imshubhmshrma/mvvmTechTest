//
//  TestNetworkLayer.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 07/01/26.
//
import XCTest
@testable import MVVMTechTestLBG

final class TestNetworkLayer: XCTestCase{
    
    var network: NetworkLayer!
    var session: URLSession!
    let validJSON = """
        {
          "users": [
            {
              "id": 1,
              "firstName": "Emily",
              "lastName": "Johnson",
              "maidenName": "Smith",
              "image": "https://dummyjson.com/icon/emilys/128"
            }
          ]
        }
        """.data(using: .utf8)
    
    let inValidJSON = """
        {
           "invalid"
        }
        """.data(using: .utf8)
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        self.network = NetworkLayer(session: session)
    }
    
    override func tearDown() {
        MockURLProtocol.clearStubs()
        self.network = nil
        self.session = nil
        super.tearDown()
    }
   
    func test_api_success_200() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: validJSON, response: response, error: nil)
        
        let result = await network.makeGetRequest(url: Constants.apiURL)
        let expectation = expectation(description: "test_api_success_200")
        
        switch result{
        case .success(let data):
            XCTAssertNotNil(data)
            expectation.fulfill()
        case .failure(_):
            XCTFail("it failed")
        }
        await fulfillment(of: [expectation],timeout: 1)
    }
    
    func test_api_failure_500() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: inValidJSON, response: response, error: nil)
        
        let expectation = expectation(description: "test_api_failure_500")
        
        let result = await network.makeGetRequest(url: Constants.apiURL)
        switch result{
        case .success(_):
            XCTFail("failed")
            
        case .failure(let error):
            XCTAssertNotNil(error)
            expectation.fulfill()
        }  
        await fulfillment(of: [expectation],timeout: 1)
    }
    
    func test_no_internet_case() async {
        let error = URLError(.notConnectedToInternet)
        
        MockURLProtocol.mockStubs(data: nil, response: nil, error: error)
        
        let expectation = expectation(description: "test_no_internet_case")
        
        let result = await network.makeGetRequest(url: Constants.apiURL)
        switch result{
        case .success(_):
            XCTFail("failed")
        case .failure(let error):
            XCTAssertEqual(error, APIError.networkFailure)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation],timeout: 1)
    }
    
    func test_invalid_reponse_failure() async {
        MockURLProtocol.mockStubs(data: Data(), response: nil, error: APIError.invalidResponse)
        
        let result = await network.makeGetRequest(url: Constants.apiURL)
        switch result{
        case .success(_):
            XCTFail("failed")
        case .failure(let error):
            XCTAssertEqual(error, .invalidResponse)
        }
    }
    
    //edge case
    func test_valid_statuscode_invalid_data() async {
        let respone = HTTPURLResponse(url: Constants.apiURL, statusCode: 206, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: Data(), response: respone, error: nil)
        
        let result = await network.makeGetRequest(url: Constants.apiURL)
        switch result{
        case .success(let data):
            XCTAssertEqual(data.isEmpty, true)
        case .failure(_):
            XCTFail("failed")
        }
    }
    
}

 
