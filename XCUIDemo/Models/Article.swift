import Foundation

nonisolated enum NewsCategory: String, CaseIterable, Identifiable {
    case all
    case tech
    case sports
    case culture

    var id: String { rawValue }

    var label: String {
        switch self {
        case .all: "Todas"
        case .tech: "Tecnología"
        case .sports: "Deportes"
        case .culture: "Cultura"
        }
    }
}

nonisolated struct Article: Identifiable, Hashable {
    let id: Int
    let title: String
    let summary: String
    let body: String
    let category: NewsCategory
}
