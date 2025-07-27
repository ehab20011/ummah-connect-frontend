import SwiftUI

struct RootView: View {
    @EnvironmentObject var session: UserSession
    @State private var screen: ScreenState = .splash

    enum ScreenState { case splash, auth, home }

    var body: some View {
        Group {
            switch screen {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .auth:
                NavigationStack { LoginView() }
                    .transition(.opacity)
            case .home:
                HomeView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { screen = session.isLoggedIn ? .home : .auth }
            }
        }
        .onChange(of: session.isLoggedIn) { loggedIn in
            withAnimation { screen = loggedIn ? .home : .auth }
        }
    }
}

#Preview {
    RootView().environmentObject(UserSession())
}
