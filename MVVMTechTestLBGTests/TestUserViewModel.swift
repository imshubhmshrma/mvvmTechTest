//
//  TestUserViewModel.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import XCTest
@testable import MVVMTechTestLBG

final class TestUserViewModel: XCTestCase{
    var network: NetworkLayer!
    var session: URLSession!
    var service: UserService!
    var userVM: UserViewModel!
    var coordinator: AppCoordinator!
    
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
        self.session = URLSession(configuration: config)
        self.network = NetworkLayer(session: session)
        self.service = UserService(network: network)
        self.userVM = UserViewModel(service: service, coordinator: coordinator)
    }
    
    @MainActor
    func test_get_user_success() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: validJSON, response: response, error: nil)
        
        await self.userVM.loadUsers()
        XCTAssertEqual(self.userVM.users.count, 1)
    }
    
    @MainActor
    func test_get_users_failure() async{
        let response = HTTPURLResponse(url: Constants.apiURL, statusCode: 300, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockStubs(data: inValidJSON, response: response, error: nil)
        
        await self.userVM.loadUsers()
        XCTAssertEqual(self.userVM.users.isEmpty,true)
    }
    
    
    @MainActor
    func test_get_users_failure_network_error() async{
        MockURLProtocol.mockStubs(data: nil, response: nil, error: APIError.networkFailure)
        await self.userVM.loadUsers()
        XCTAssertEqual(self.userVM.errorMessage,APIError.networkFailure.localizedDescription)
    } 
}
