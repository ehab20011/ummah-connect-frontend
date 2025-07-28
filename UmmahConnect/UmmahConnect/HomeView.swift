import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: UserSession
    @State private var profile: UserProfile?
    @State private var isLoadingProfile = false
    @State private var profileError: String?
    @State private var showWelcome = true
    @State private var selectedTab = "Donations"

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()

                if showWelcome, let prof = profile {
                    VStack(spacing: 12) {
                        Image("welcome-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220)

                        Text(prof.display_name ?? prof.username)
                            .font(.title2.weight(.semibold))
                    }
                    .multilineTextAlignment(.center)
                    .transition(.opacity.combined(with: .scale))
                } else if isLoadingProfile {
                    ProgressView()
                } else if let error = profileError {
                    Text("Failed to load profile: \(error)")
                        .foregroundColor(.red)
                } else {
                    switch selectedTab {
                    case "Donations":
                        Text("Donations View")
                            .font(.title)
                    case "Volunteering":
                        Text("Volunteering View")
                            .font(.title)
                    case "Profile":
                        if let prof = profile {
                            Text("Profile: \(prof.display_name ?? prof.username)")
                                .font(.title)
                        } else {
                            Text("Profile")
                                .font(.title)
                        }
                    default:
                        EmptyView()
                    }
                }

                Spacer()
            }
            .animation(.easeInOut, value: showWelcome)

            if !showWelcome {
                ModernFooter(selectedTab: $selectedTab)
                    .transition(.opacity)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: fetchProfile)
    }

    private func fetchProfile() {
        guard let token = session.token else { return }
        isLoadingProfile = true
        UserService.fetchCurrentUser(token: token) { result in
            DispatchQueue.main.async {
                isLoadingProfile = false
                switch result {
                case .success(let prof):
                    self.profile = prof
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { self.showWelcome = false }
                    }
                case .failure(let err):
                    self.profileError = err.localizedDescription
                }
            }
        }
    }
}
