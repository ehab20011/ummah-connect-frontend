import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.93)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    Image("logo-nobg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)

                    Text("Welcome to UmmahConnect")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Text("Connecting Muslims everywhere")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    VStack(spacing: 16) {
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.teal)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: LoginView()) {
                            Text("Log In")
                                .font(.headline)
                                .foregroundColor(Color.teal)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.teal, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
