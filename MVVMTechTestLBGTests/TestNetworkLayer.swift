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
        self.session = URLSession(configuration: config)
        self.network = NetworkLayer(session: session)
    }
    
    override func tearDown() {
        MockURLProtocol.clearStubs()
        self.network = nil
        self.session = nil
        super.tearDown()
    }
    @MainActor
    func test_api_success_200() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: validJSON, response: response, error: nil)
       
      //  let expectation = expectation(description: "test_api_success_200")
        do{
            let result = try await network.makeGetRequest(url: Constants.apiURL)
            XCTAssertNotNil(result)
     //       expectation.fulfill()
        }catch(let error as APIError){
            XCTAssertNotNil(error) 
       //     expectation.fulfill()
        }catch{
            XCTFail("failed")
        }
      
       // await fulfillment(of: [expectation],timeout: 1)
    }
    @MainActor
    func test_api_failure_500() async{
        let response =  HTTPURLResponse(url: Constants.apiURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: nil, response: response, error: nil)
        do{
            _ = try await self.network.makeGetRequest(url: Constants.apiURL)
        } catch(let error){
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? APIError, APIError.serverError) 
        }
    }
    
    func test_no_internet_case() async {
        let error = URLError(.notConnectedToInternet)
        
        MockURLProtocol.mockStubs(data: nil, response: nil, error: error)
        
        let expectation = expectation(description: "test_no_internet_case")
        do{
            _ = try await network.makeGetRequest(url: Constants.apiURL)
        }catch(let error as APIError){
            XCTAssertEqual(error, APIError.networkFailure)
            expectation.fulfill()
        } catch{
            XCTFail("failed")
        }
         
        await fulfillment(of: [expectation],timeout: 1)
    }
  
    
    //edge case
    func test_valid_statuscode_invalid_data() async {
        let respone = HTTPURLResponse(url: Constants.apiURL, statusCode: 206, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: Data(), response: respone, error: nil)
        do{
            let result = try await network.makeGetRequest(url: Constants.apiURL)
            XCTAssertEqual(result.isEmpty, true)
        }catch{
            XCTFail("failed")
        }
       
    }
    
}

 
