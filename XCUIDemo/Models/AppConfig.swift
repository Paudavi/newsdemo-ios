import Foundation

/// "Ganchos" para tests: el test los manda al abrir la app y la app se configura sola.
///
/// Desde un test de XCUITest:
///     app.launchArguments = ["-uiTesting", "-loggedIn"]
///     app.launchEnvironment = ["NETWORK_DELAY_MS": "0"]
///     app.launch()
enum AppConfig {

    /// Borra las preferencias guardadas (empezar como recién instalada).
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-uiTesting")
    }

    /// Entra directo al feed, sin pasar por el login.
    static var startLoggedIn: Bool {
        ProcessInfo.processInfo.arguments.contains("-loggedIn")
    }

    /// Muestra la pantalla de la lección 0 (el saludo) en vez de la app de noticias.
    static var showGreetingDemo: Bool {
        ProcessInfo.processInfo.arguments.contains("-greetingDemo")
    }

    /// Demora simulada de la "red", en milisegundos (por defecto 1500).
    static var networkDelayMs: Int {
        Int(ProcessInfo.processInfo.environment["NETWORK_DELAY_MS"] ?? "") ?? 1500
    }
}
