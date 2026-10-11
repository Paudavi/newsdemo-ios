import SwiftUI

struct ArticleDetailView: View {
    @Environment(ArticleStore.self) private var store
    let articleID: Int

    var body: some View {
        if let article = store.article(id: articleID) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(article.category.label)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("articleCategory")

                    Text(article.title)
                        .font(.title2.bold())
                        .accessibilityIdentifier("articleTitle")

                    Text(article.body)
                        .accessibilityIdentifier("articleBody")

                    HStack {
                        Button(store.isLiked(article.id) ? "Te gusta ♥" : "Me gusta") {
                            store.toggleLike(article.id)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("likeButton")

                        // Abre la hoja de "Compartir" del SISTEMA
                        ShareLink(
                            item: URL(string: "newsdemo://article/\(article.id)")!,
                            subject: Text(article.title),
                            message: Text(article.title)
                        ) {
                            Label("Compartir", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("shareButton")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("Noticia")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("No encontramos este artículo")
                .accessibilityIdentifier("notFoundText")
        }
    }
}
