
import XCTest

extension XCUIElement {
    var isDisable: Bool { !isEnabled }
    
    func tapAndType(_ text: String) {
        tap()
        typeText(text)
    }
    
    func tapAndClear(_ count: Int) {
        tap()
        typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: count))
    }
    ///Doesn't work for SecureTextField
    func tapAndClear(file: StaticString = #filePath, line: UInt = #line) {
        tap(withNumberOfTaps: 3, numberOfTouches: 1)
        typeText(XCUIKeyboardKey.delete.rawValue)
        let input = value as? String ?? ""
        if (input != "" && input != placeholderValue){
            XCTFail("Field couldn't be cleared. Remaining text: '\(input)'", file: file, line: line)
        }
    }
}
