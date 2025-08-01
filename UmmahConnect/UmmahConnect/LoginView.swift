import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var session: UserSession

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.93)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 50)

                    Text("Log In")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)

                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                    }
                    .padding(.horizontal, 30)

                    Button(action: {
                        AuthService.login(email: email, password: password) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let token):
                                    session.login(with: token)
                                case .failure(let error):
                                    print("Login failed: \(error.localizedDescription)")
                                }
                            }
                        }
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)

                    // Divider with "OR"
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.4))
                        Text("OR")
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.4))
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                    // Social login placeholders
                    VStack(spacing: 12) {
                        Button(action: {
                            print("Google Sign-In Tapped")
                        }) {
                            HStack {
                                Image("google") // or use a Google logo asset
                                Text("Sign in with Google")
                            }
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        }

                        Button(action: {
                            print("Apple Sign-In Tapped")
                        }) {
                            HStack {
                                Image(systemName: "applelogo")
                                Text("Sign in with Apple")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)

                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.teal)
                            .padding(.top, 10)
                    }

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserSession())
}
