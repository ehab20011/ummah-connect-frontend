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
                                    session.login(with: token) // <-- uses shared session
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
        .environmentObject(UserSession()) // required for preview
}
