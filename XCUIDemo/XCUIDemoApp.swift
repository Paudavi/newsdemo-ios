import SwiftUI
import UserNotifications

@main
struct XCUIDemoApp: App {

    @State private var session = Session(currentUser: AppConfig.startLoggedIn ? Session.demoEmail : nil)
    @State private var store = ArticleStore()
    private let notificationDelegate = NotificationDelegate()

    init() {
        if AppConfig.isUITesting {
            // Start as a fresh install, no preferences saved
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
        }
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            if AppConfig.showGreetingDemo {
                ContentView() // Lección 0
            } else {
                RootView()
                    .environment(session)
                    .environment(store)
            }
        }
    }
}
