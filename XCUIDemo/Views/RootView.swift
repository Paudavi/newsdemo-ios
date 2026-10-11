import SwiftUI

enum Route: Hashable {
    case article(Int)
    case settings
}

/// Decide qué mostrar (login o feed) y maneja la navegación y los deep links.
struct RootView: View {
    @Environment(Session.self) private var session
    @State private var path: [Route] = []

    var body: some View {
        Group {
            if session.isLoggedIn {
                NavigationStack(path: $path) {
                    FeedView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .article(let id):
                                ArticleDetailView(articleID: id)
                            case .settings:
                                SettingsView()
                            }
                        }
                }
            } else {
                LoginView()
            }
        }
        // Deep link: newsdemo://article/5 abre el artículo 5
        .onOpenURL { url in
            guard url.scheme == "newsdemo", url.host() == "article",
                  let id = Int(url.lastPathComponent) else { return }
            path = [.article(id)]
        }
        .onChange(of: session.isLoggedIn) {
            path = []
        }
    }
}
