import SwiftUI

struct FeedView: View {
    @Environment(Session.self) private var session
    @Environment(ArticleStore.self) private var store

    @State private var query = ""
    @State private var category: NewsCategory = .all

    private var visibleArticles: [Article] {
        store.filtered(query: query, category: category)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Hola, \(session.currentUser ?? "")")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .accessibilityIdentifier("welcomeText")

            TextField("Buscar noticias", text: $query)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal)
                .accessibilityIdentifier("searchInput")

            Picker("Categoría", selection: $category) {
                ForEach(NewsCategory.allCases) { category in
                    Text(category.label).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .accessibilityIdentifier("categoryPicker")

            content
        }
        .navigationTitle("NewsDemo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: Route.settings) {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel("Ajustes")
                .accessibilityIdentifier("settingsButton")
            }
        }
        .task {
            if store.articles.isEmpty {
                await store.load()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading && store.articles.isEmpty {
            Spacer()
            ProgressView("Cargando…")
                .accessibilityIdentifier("loadingIndicator")
            Spacer()
        } else if visibleArticles.isEmpty {
            Spacer()
            Text("No encontramos noticias")
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("emptyState")
            Spacer()
        } else {
            List(visibleArticles) { article in
                NavigationLink(value: Route.article(article.id)) {
                    ArticleRow(article: article)
                }
                .accessibilityIdentifier("articleRow_\(article.id)")
                // Deslizar la fila hacia la izquierda muestra "Me gusta"
                .swipeActions(edge: .trailing) {
                    Button(store.isLiked(article.id) ? "Quitar" : "Me gusta") {
                        store.toggleLike(article.id)
                    }
                    .tint(.pink)
                    .accessibilityIdentifier("swipeLike_\(article.id)")
                }
            }
            .listStyle(.plain)
            .accessibilityIdentifier("articleList")
            // Tirar la lista hacia abajo recarga (pull to refresh)
            .refreshable {
                await store.load()
            }
        }
    }
}

struct ArticleRow: View {
    @Environment(ArticleStore.self) private var store
    let article: Article

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                Text(article.category.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(article.summary)
                    .font(.subheadline)
            }
            Spacer()
            if store.isLiked(article.id) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .accessibilityLabel("Te gusta")
                    .accessibilityIdentifier("likedIcon_\(article.id)")
            }
        }
    }
}
