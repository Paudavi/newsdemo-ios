import XCTest

struct LoginScreen {
    let app: XCUIApplication
    
    var loginButton: XCUIElement { app.buttons["loginButton"] }
    
    var emailInput: XCUIElement { app.textFields["emailInput"] }
    
    var passInput: XCUIElement { app.secureTextFields["passwordInput"] }
    
    var errorMessage: XCUIElement { app.staticTexts["errorText"] }
    
    func login(email:String, password: String, file: StaticString = #filePath, line: UInt = #line) {
        emailInput.tapAndType(email)
        passInput.tapAndType(password)
        XCTAssertTrue(loginButton.isEnabled, "Ingresar is not enabled", file: file, line: line)
        loginButton.tap()
    }
    
}
