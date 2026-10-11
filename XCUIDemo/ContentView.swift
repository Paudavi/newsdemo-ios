import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var greeting = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Tu nombre", text: $name)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("nameInput")

            Button("Saludar") {
                greeting = "Hola, \(name)"
            }
            .accessibilityIdentifier("greetButton")

            Text(greeting)
                .accessibilityIdentifier("greetingText")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
