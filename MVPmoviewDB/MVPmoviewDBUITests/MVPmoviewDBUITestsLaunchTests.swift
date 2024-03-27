//
//  MVPmoviewDBUITestsLaunchTests.swift
//  MVPmoviewDBUITests
//
//  Created by Felipe Araujo on 26/03/24.
//

import XCTest
@testable import MVPmoviewDB

final class MVPmoviewDBUITestsLaunchTests: XCTestCase {
    var app: XCUIApplication!
    
    override class func setUp() {
        super.setUp()
    }
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }
    
    func testMyNavBar() {
        let app = XCUIApplication()
        
        let navBar = app.navigationBars["Movies"]
        XCTAssert(navBar.exists)
        
        let searchBar = navBar.searchFields["Search Movies"]
        XCTAssert(searchBar.exists)
        
        searchBar.tap()
        
        let cancelButton = navBar.buttons["Cancel"]
        XCTAssert(cancelButton.exists)
        
        cancelButton.tap()
        
    }
    
    func testMyTableView() {
//        let customTableView = self.app.tables["tableViewID"]
//        XCTAssertTrue(customTableView.exists)
    }
    
    
    func testMovieDetailsView(){
        let app = XCUIApplication()
        
        let tableCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Kung Fu Panda 4"]
        
        XCTAssert(tableCell.exists)
        
        tableCell.tap()
        
        
        
    }
    
    
    func testLaunch() throws {
        
        
        //        let app = XCUIApplication()
        //        app.launch()
        //        XCTAssert(app.navigationBars["Movies"].staticTexts["Movies"].exists)
        
        //XCTAssert(app.naviga)
        
        
        //        let navTitle = app.navigationBars.staticTexts["Movies"]
        //        XCTAssertTrue(navTitle.exists)
        
        //        let searchBar = moviesNavigationBar.searchFields["Search Movies"]
        //        XCTAssertTrue(searchBar.exists)
        
        
        //        let searchBar = moviesNavigationBar.searchFields["Search Movies"]
        //        XCTAssertTrue(searchBar.exists)
        //
        //        searchBar.tap()
        //        let cancelButton = moviesNavigationBar.buttons["Cancel"]
        //        XCTAssertTrue(cancelButton.exists)
        //
        //        cancelButton.tap()
        
        
        //        let tablesQuery = app.tables
        //        tablesQuery.staticTexts["Popular"].tap()
        //        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past."].tap()
        //
        //        let moviesButton = app.navigationBars["Details"].buttons["Movies"]
        //        moviesButton.tap()
        //        tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts["Forced to confront revelations about her past, paramedic Cassandra Webb forges a relationship with three young women destined for powerful futures...if they can all survive a deadly present."].tap()
        //        moviesButton.tap()
        //                app.launch()
        
        
        
        //        let attachment = XCTAttachment(screenshot: app.screenshot())
        //        attachment.name = "Launch Screen"
        //        attachment.lifetime = .keepAlways
        //        add(attachment)
    }
}
