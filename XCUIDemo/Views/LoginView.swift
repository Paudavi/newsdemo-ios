import SwiftUI

struct LoginView: View {
    @Environment(Session.self) private var session

    @State private var email = ""
    @State private var password = ""
    @State private var error: LoginError?

    private var canSubmit: Bool {
        !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("NewsDemo")
                .font(.largeTitle.bold())
                .accessibilityIdentifier("loginTitle")

            Text("Ingresá para ver las noticias")
                .foregroundStyle(.secondary)

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("emailInput")

            SecureField("Contraseña", text: $password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("passwordInput")

            if let error {
                Text(error.message)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("errorText")
            }

            Button("Ingresar") {
                error = session.login(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .disabled(!canSubmit)
            .accessibilityIdentifier("loginButton")

            Text("Demo: pau@test.com / 123456")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("demoHint")
        }
        .padding(24)
        // El error desaparece cuando el usuario edita un campo
        .onChange(of: email) { error = nil }
        .onChange(of: password) { error = nil }
    }
}

#Preview {
    LoginView().environment(Session())
}
