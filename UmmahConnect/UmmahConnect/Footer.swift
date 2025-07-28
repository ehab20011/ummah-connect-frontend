import SwiftUI

struct ModernFooter: View {
    @Binding var selectedTab: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    selectedTab = "Donations"
                }) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(selectedTab == "Donations" ? .blue : .gray)
                }

                Spacer()

                Button(action: {
                    selectedTab = "Volunteering"
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(selectedTab == "Volunteering" ? .blue : .gray)
                }

                Spacer()

                Button(action: {
                    selectedTab = "Profile"
                }) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(selectedTab == "Profile" ? .blue : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            .padding(.top, 12)
            .padding(.bottom, 30)

            // Home indicator
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 120, height: 5)
                .foregroundColor(.black.opacity(0.9))
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity) // Ensures background stretches full width
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: -2)
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
    }
}
