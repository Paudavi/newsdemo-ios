//
//  GreetingUITest.swift
//  XCUIDemoUITests
//
//  Created by Pau Davi on 11/10/26.
//

import XCTest

final class GreetingUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    @MainActor
    func testShowsGreetingWithTypedName() throws {
        let app = XCUIApplication()
        app.launch()
        
        let nameInput = app.textFields["nameInput"]
        XCTAssertTrue(nameInput.waitForExistence(timeout: 5))
        nameInput.tap()
        nameInput.typeText("Pau")
        
        app.buttons["greetButton"].tap()
        
        let greeting = app.staticTexts["greetingText"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 5))
        XCTAssertEqual(greeting.label, "Hola, Pau")
    }
}

