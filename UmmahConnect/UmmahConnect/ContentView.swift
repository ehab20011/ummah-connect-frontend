import SwiftUI

struct ContentView: View {
    @State private var showWelcome = false

    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView()
                    .transition(.opacity)
            } else {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 1.0), value: showWelcome)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showWelcome = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
