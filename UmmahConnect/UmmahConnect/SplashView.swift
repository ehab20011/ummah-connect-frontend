import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            // Slightly warmer and richer tone than plain white
            Color(red: 0.97, green: 0.96, blue: 0.93)
                .ignoresSafeArea()

            Image("logo-nobg")
                .resizable()
                .scaledToFit()
                .frame(width: 300) // Increased size
                .padding(.bottom, -20) // Slight vertical nudge
        }
    }
}

#Preview {
    SplashView()
}
