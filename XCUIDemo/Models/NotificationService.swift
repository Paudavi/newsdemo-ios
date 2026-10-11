import Foundation
import UserNotifications

/// Muestra los banners de notificación aunque la app esté abierta
/// (por defecto iOS no los muestra si la app está en primer plano).
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }
}

enum NotificationService {

    /// Muestra el popup del SISTEMA "¿Permitir notificaciones?".
    /// Ese popup no es de la app: en los tests se maneja distinto (ver la guía).
    static func requestPermission() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    static func isAuthorized() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    /// Programa una notificación local que aparece a los `seconds` segundos.
    static func scheduleTestNotification(after seconds: TimeInterval = 2) async {
        let content = UNMutableNotificationContent()
        content.title = "NewsDemo"
        content.body = "Tenés noticias nuevas"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "test-news", content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }
}
