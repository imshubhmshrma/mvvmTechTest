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
        do{
            let result = try await self.service.getUsers()
            //Assert
            XCTAssertNotNil(result)
        } catch {
            XCTFail("failures in loading users")
        }
    }
    
    
    func test_failure_invalid_json_status_code_300() async{
        //Arrange
        let response = await HTTPURLResponse(url: Constants.apiURL, statusCode: 300, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: inValidJSON, response: response, error: nil)
        //Act
        do{
           _ = try await self.service.getUsers()
        }catch(let error){
            XCTAssertEqual(error as? APIError, APIError.invalidStatusCode)
        }
    }
    
    @MainActor
    func test_failure_invalid_json_status_code_500() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: nil, response: response, error: nil)
        do{
            _ = try await service.getUsers()
        }catch(let error){
            XCTAssertEqual(error as? APIError, APIError.serverError)
        }
    }
    
    func test_no_internet() async{
        MockURLProtocol.mockStubs(data: nil, response: nil, error: APIError.networkFailure)
        do{
            _ = try await service.getUsers()
        } catch(let error as APIError) {
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .networkFailure)
        }catch{
            XCTFail("Catch called test_no_internet")
        }
        
    }
}
