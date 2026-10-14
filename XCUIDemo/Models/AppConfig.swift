import Foundation

enum AppConfig {

    static var isUITesting: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-uiTesting")
        #else
        return false
        #endif
    }

    static var startLoggedIn: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-loggedIn")
        #else
        return false
        #endif
    }

    static var showGreetingDemo: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-greetingDemo")
        #else
        return false
        #endif
    }

    static var networkDelayMs: Int {
        #if DEBUG
        return Int(ProcessInfo.processInfo.environment["NETWORK_DELAY_MS"] ?? "") ?? 1500
        #else
        return 1500
        #endif
    }
}
