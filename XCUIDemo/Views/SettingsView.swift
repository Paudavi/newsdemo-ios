import SwiftUI

enum FontSize: String, CaseIterable, Identifiable {
    case small, medium, large

    var id: String { rawValue }

    var label: String {
        switch self {
        case .small: "Chica"
        case .medium: "Mediana"
        case .large: "Grande"
        }
    }

    var points: CGFloat {
        switch self {
        case .small: 14
        case .medium: 18
        case .large: 24
        }
    }
}

struct SettingsView: View {
    @Environment(Session.self) private var session

    // @AppStorage guarda en disco: sobrevive a cerrar y volver a abrir la app
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("fontSize") private var fontSize: FontSize = .medium

    private static let deniedMessage = "Permiso de notificaciones denegado"

    @State private var statusMessage = ""
    @State private var showLogoutAlert = false

    var body: some View {
        Form {
            Section("Notificaciones") {
                Toggle("Notificaciones", isOn: $notificationsEnabled)
                    .accessibilityIdentifier("notificationsToggle")

                Text(statusMessage.isEmpty ? defaultStatus : statusMessage)
                    .accessibilityIdentifier("notificationsStatus")

                Button("Enviar notificación de prueba") {
                    Task {
                        await NotificationService.scheduleTestNotification()
                        statusMessage = "Notificación programada"
                    }
                }
                .disabled(!notificationsEnabled)
                .accessibilityIdentifier("testNotificationButton")
            }

            Section("Tamaño de letra") {
                Picker("Tamaño", selection: $fontSize) {
                    ForEach(FontSize.allCases) { size in
                        Text(size.label).tag(size)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityIdentifier("fontSizePicker")

                Text("Tamaño seleccionado: \(fontSize.label)")
                    .accessibilityIdentifier("fontSelectedLabel")

                Text("Así se ve el texto de una noticia")
                    .font(.system(size: fontSize.points))
                    .accessibilityIdentifier("fontPreview")
            }

            Section {
                Button("Cerrar sesión", role: .destructive) {
                    showLogoutAlert = true
                }
                .accessibilityIdentifier("logoutButton")
            }
        }
        .navigationTitle("Ajustes")
        .onChange(of: notificationsEnabled) { _, isOn in
            guard isOn else {
                // Si se apagó porque negaron el permiso, dejamos ese mensaje visible
                if statusMessage != Self.deniedMessage { statusMessage = "" }
                return
            }
            Task {
                // Primera vez: aparece el popup del sistema "¿Permitir notificaciones?"
                let granted = await NotificationService.requestPermission()
                if !granted {
                    notificationsEnabled = false
                    statusMessage = Self.deniedMessage
                } else {
                    statusMessage = ""
                }
            }
        }
        // Alerta de la APP (no del sistema): se maneja con app.alerts en XCUITest
        .alert("¿Cerrar sesión?", isPresented: $showLogoutAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Sí, salir", role: .destructive) {
                session.logout()
            }
        } message: {
            Text("Vas a tener que ingresar de nuevo.")
        }
    }

    private var defaultStatus: String {
        notificationsEnabled ? "Notificaciones activadas" : "Notificaciones desactivadas"
    }
}
