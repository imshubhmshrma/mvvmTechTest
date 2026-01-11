//
//  UsersListViewUITests.swift
//  MVVMTechTestLBG
//
//  Created by Shubham Sharma on 08/01/26.
//

import XCTest
@testable import MVVMTechTestLBG

final class UsersListViewUITests: XCTestCase{
    
    var app: XCUIApplication!
    var network: NetworkLayer!
    var session: URLSession!
    var service: UserService!
    var vm: UserViewModel!
    
    override func setUp() {
        super.setUp()
        self.app = XCUIApplication()
        continueAfterFailure = true
        self.app.launch()
        
    }
    
    func test_check_nav_bar_visible(){
        let navBar = app.navigationBars["Users"]
        XCTAssertEqual(navBar.identifier, "Users") 
    }
    
    func test_check_list_loads(){
        let list = app.collectionViews["UsersListView"]
        XCTAssertTrue(list.waitForExistence(timeout: 2))
        XCTAssertEqual(list.cells.count > 1, true)
    }
    
    func test_first_cell_content(){
        let cellOneName = app.staticTexts["UserCellView_txt_FName_N_LName_1"]
        XCTAssertEqual(cellOneName.label, "Emily Johnson") 
    }
}

