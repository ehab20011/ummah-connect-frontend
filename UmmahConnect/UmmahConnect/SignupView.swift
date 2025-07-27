import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) private var dismiss

    // Basic fields
    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    // Masjid toggle + fields
    @State private var isMasjid = false
    @State private var address = ""
    @State private var city = ""
    @State private var stateField = ""
    @State private var country = ""
    @State private var ein = ""

    // UI state
    @State private var isLoading = false
    @State private var errorMsg: String?
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.93).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 50)

                    Text("Create Account")
                        .font(.title.bold())

                    // Core fields
                    VStack(spacing: 16) {
                        TextField("Full Name (display name)", text: $name)
                            .textContentType(.name)
                            .styledField()

                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .styledField()

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .styledField()

                        TextField("Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                            .styledField()

                        SecureField("Password", text: $password)
                            .textContentType(.newPassword)
                            .styledField()

                        SecureField("Confirm Password", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .styledField()

                        Toggle("Signing up as a Masjid?", isOn: $isMasjid)
                            .padding(.horizontal, 30)
                            .toggleStyle(SwitchToggleStyle(tint: .teal))
                    }
                    .padding(.horizontal, 30)

                    // Masjid fields (conditionally shown)
                    if isMasjid {
                        VStack(spacing: 16) {
                            TextField("Address", text: $address).styledField()
                            TextField("City", text: $city).styledField()
                            TextField("State", text: $stateField).styledField()
                            TextField("Country", text: $country).styledField()
                            TextField("EIN", text: $ein).styledField()
                        }
                        .padding(.horizontal, 30)
                    }

                    Button {
                        submit()
                    } label: {
                        if isLoading {
                            ProgressView().tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.teal)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .disabled(isLoading)

                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Log In")
                            .font(.subheadline)
                            .foregroundColor(.teal)
                            .padding(.top, 10)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .alert("Signup Error", isPresented: $showAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(errorMsg ?? "Unknown error")
        })
    }

    private func submit() {
        errorMsg = nil

        // Basic validation
        guard !email.isEmpty, !username.isEmpty, !password.isEmpty, !phone.isEmpty else {
            errorMsg = "Please fill all required fields."
            showAlert = true
            return
        }
        guard password == confirmPassword else {
            errorMsg = "Passwords do not match."
            showAlert = true
            return
        }
        if isMasjid {
            let masjidFields = [address, city, stateField, country, ein]
            if masjidFields.contains(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) {
                errorMsg = "All masjid fields are required."
                showAlert = true
                return
            }
        }

        isLoading = true

        let payload = SignupPayload(
            email: email.lowercased().trimmingCharacters(in: .whitespaces),
            username: username.lowercased().trimmingCharacters(in: .whitespaces),
            password: password,
            is_masjid: isMasjid,
            display_name: name.isEmpty ? username : name,
            phone_number: phone,
            profile_pic_url: nil,
            address: isMasjid ? address : nil,
            city: isMasjid ? city : nil,
            state: isMasjid ? stateField : nil,
            country: isMasjid ? country : nil,
            ein: isMasjid ? ein : nil
        )

        AuthService.signup(payload: payload) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let token):
                    session.login(with: token)
                    dismiss()
                case .failure(let err):
                    errorMsg = err.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

// MARK: - Styling helper
private extension View {
    func styledField() -> some View {
        self.padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 1)
    }
}

#Preview {
    NavigationView {
        SignUpView()
            .environmentObject(UserSession())
    }
}
