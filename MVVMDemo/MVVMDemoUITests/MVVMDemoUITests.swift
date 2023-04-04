//
//  MVVMDemoUITests.swift
//  MVVMDemoUITests
//
//  Created by Natalia Pashkova on 03.04.2023.
//

import XCTest
@testable import MVVMDemo

final class MVVMDemoUITests: XCTestCase {
    let tableView = UITableView()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        tableView.reloadData()
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        let title = app.staticTexts["Users"]
        XCTAssertTrue(title.exists)
        
        let button = app.buttons["Add"]
        XCTAssertTrue(button.exists)
    }
    func testLastSection() {
        XCTAssertEqual(tableView.numberOfSections, 1)
    }
    
    func testDequeueReusableCellWithClass() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell")
        XCTAssertNotNil(cell)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
