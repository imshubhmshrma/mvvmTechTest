//
    //  TestServiceLayer.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import XCTest
@testable import MVVMTechTestLBG

final class TestUserServiceLayer: XCTestCase{
    var service: UserService!
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
               "Invalid"
        """.data(using: .utf8)
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        self.network = NetworkLayer(session: session)
        self.service = UserService(network: network)
    }
    
    
    func test_success_case_status_code_200() async {
        //Arrange
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: validJSON, response: response, error: nil)
        //Act
        let result = await self.service.getUsers()
        switch result{
        case .success(let users):
            //Assert
            XCTAssertNotNil(users)
        case .failure(_):
            XCTFail("failures in loading users")
        }
    }
    
    
    func test_failure_invalid_json_status_code_300() async{
        //Arrange
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 300, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: inValidJSON, response: response, error: nil)
        //Act
        let result = await self.service.getUsers()
        switch result{
        case .success(_):
            XCTFail("failures in loading users")
        case .failure(let error):
            XCTAssertEqual(error, APIError.invalidStatusCode)
        }
    }
    
    
    func test_failure_invalid_json_status_code_500() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: nil, response: response, error: nil)
        
        let result = await service.getUsers()
        switch result{
        case .success(_):
            XCTFail("failures in loading users")
        case .failure(let error):
            XCTAssertEqual(error, APIError.serverError)
        }
    }
    
}
