import Foundation
import Observation

nonisolated enum LoginError: Equatable {
    case emptyEmail
    case invalidEmail
    case shortPassword
    case invalidCredentials

    var message: String {
        switch self {
        case .emptyEmail: "Ingresá tu email"
        case .invalidEmail: "El email no es válido"
        case .shortPassword: "La contraseña debe tener al menos 6 caracteres"
        case .invalidCredentials: "Email o contraseña incorrectos"
        }
    }
}

/// Lógica pura, sin pantallas: ideal para unit tests (target XCUIDemoTests).
nonisolated enum LoginValidator {
    static let minPasswordLength = 6

    static func validate(email: String, password: String) -> LoginError? {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return .emptyEmail }
        if trimmed.range(of: #"^[^@\s]+@[^@\s]+\.[^@\s]+$"#, options: .regularExpression) == nil {
            return .invalidEmail
        }
        if password.count < minPasswordLength { return .shortPassword }
        return nil
    }
}

/// Sesión en memoria. En una app real habría un backend y un token guardado.
@Observable
final class Session {
    static let demoEmail = "pau@test.com"
    static let demoPassword = "123456"

    private(set) var currentUser: String?

    var isLoggedIn: Bool { currentUser != nil }

    init(currentUser: String? = nil) {
        self.currentUser = currentUser
    }

    /// Devuelve el error, o nil si entró bien.
    func login(email: String, password: String) -> LoginError? {
        if let error = LoginValidator.validate(email: email, password: password) {
            return error
        }
        let normalized = email.trimmingCharacters(in: .whitespaces).lowercased()
        guard normalized == Self.demoEmail, password == Self.demoPassword else {
            return .invalidCredentials
        }
        currentUser = normalized
        return nil
    }

    func logout() {
        currentUser = nil
    }
}
