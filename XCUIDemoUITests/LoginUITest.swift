//
//  LoginUITest.swift
//  XCUIDemoUITests
//
//

import XCTest

final class LoginUITest: XCTestCase {
    
    var app: XCUIApplication!
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        app.launch()
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginButtonDisableAndEnable() throws {
        let loginScreen = LoginScreen(app: app)
        XCTAssertTrue(loginScreen.loginButton.isDisable, "Ingresar is not enabled")
        loginScreen.emailInput.tapAndType("pau@test.com")
        loginScreen.passInput.tapAndType("123456")
        XCTAssertTrue(loginScreen.loginButton.isEnabled, "Ingresar is enabled")
    }
    
    func testErrorMessageIncorrectPassword() throws {
        let loginScreen = LoginScreen(app: app)
        loginScreen.login(email: "pau@test.com", password: "123457")
        XCTAssertTrue(loginScreen.errorMessage.waitForExistence(timeout: 5))
        XCTAssertEqual(loginScreen.errorMessage.label, "Email o contraseña incorrectos")
    }
    
    func testErrorMessageShortPassword() throws {
        let loginScreen = LoginScreen(app: app)
        loginScreen.login(email: "pau@test.com", password: "12345")
        XCTAssertTrue(loginScreen.errorMessage.waitForExistence(timeout: 5))
        XCTAssertEqual(loginScreen.errorMessage.label, "La contraseña debe tener al menos 6 caracteres")
    }
    
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
