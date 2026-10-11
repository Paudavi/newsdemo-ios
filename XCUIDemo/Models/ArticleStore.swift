import Foundation
import Observation

/// "Backend" falso: simula una llamada de red con demora,
/// para practicar cómo esperar datos asíncronos en los tests.
@Observable
final class ArticleStore {

    private(set) var articles: [Article] = []
    private(set) var isLoading = false
    private(set) var likedIDs: Set<Int> = []

    private static let seed: [(title: String, category: NewsCategory)] = [
        ("Uruguay lanza su primer satélite educativo", .tech),
        ("Peñarol gana el clásico en el Centenario", .sports),
        ("Nueva muestra de Torres García en Montevideo", .culture),
        ("Cómo la IA está cambiando el testing de software", .tech),
        ("La Celeste se prepara para el Mundial", .sports),
        ("Feria del libro: los más vendidos del año", .culture),
        ("Apple presenta nuevas herramientas para desarrolladores", .tech),
        ("Récord de corredores en la San Felipe y Santiago", .sports),
        ("El carnaval uruguayo ya tiene fecha", .culture),
        ("Android 17: lo que hay que saber", .tech),
        ("Nacional suma un nuevo refuerzo", .sports),
        ("Cine nacional: tres estrenos para ver", .culture),
        ("Ciberseguridad: las estafas más comunes del año", .tech),
        ("Básquet: arranca la Liga Uruguaya", .sports),
        ("Murga joven: la final en el Teatro de Verano", .culture),
        ("Startups uruguayas que exportan software", .tech),
        ("Tenis: un uruguayo entre los mejores 50 del mundo", .sports),
        ("Ópera en el Solís: entradas agotadas", .culture),
        ("Guía para empezar con la automatización mobile", .tech),
        ("Rugby: Los Teros confirman su plantel", .sports),
    ]

    static let allArticles: [Article] = seed.enumerated().map { pair in
        let number = pair.offset + 1
        let title = pair.element.title
        return Article(
            id: number,
            title: title,
            summary: "Resumen de la noticia \(number).",
            body: "Este es el texto completo de \"\(title)\". En una app real vendría del backend; "
                + "acá está fijo para que los tests sean deterministas.",
            category: pair.element.category
        )
    }

    /// Simula un GET /articles.
    func load() async {
        isLoading = true
        try? await Task.sleep(for: .milliseconds(AppConfig.networkDelayMs))
        articles = Self.allArticles
        isLoading = false
    }

    func article(id: Int) -> Article? {
        Self.allArticles.first { $0.id == id }
    }

    func isLiked(_ id: Int) -> Bool {
        likedIDs.contains(id)
    }

    func toggleLike(_ id: Int) {
        if likedIDs.contains(id) {
            likedIDs.remove(id)
        } else {
            likedIDs.insert(id)
        }
    }

    func filtered(query: String, category: NewsCategory) -> [Article] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        return articles.filter { article in
            (category == .all || article.category == category)
                && (trimmed.isEmpty || article.title.localizedCaseInsensitiveContains(trimmed))
        }
    }
}
