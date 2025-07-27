import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: UserSession

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome!")
                .font(.largeTitle.bold())

            if let userId = session.userId {
                Text("User ID: \(userId)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Button("Log out") {
                session.token = nil
                session.userId = nil
                session.isLoggedIn = false
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}
