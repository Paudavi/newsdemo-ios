
import XCTest

extension XCUIElement {
    var isDisable: Bool { !isEnabled }
    
    func tapAndType(_ text: String) {
        tap()
        typeText(text)
    }
}
