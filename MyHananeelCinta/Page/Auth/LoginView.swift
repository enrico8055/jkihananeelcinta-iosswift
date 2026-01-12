import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("userSession") var userSession: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 51/255, green: 51/255, blue: 51/255)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                HStack{
                    // Judul
                    Text("Masuk")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 32)
                    Spacer()
                }
            
                
                HStack{
                    // Subjudul
                    Text("Selamat datang di JKI Hananeel Cinta")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()
                }
                
                
                VStack(spacing: 16) {
                    
                    // EMAIL
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email") // Label selalu muncul
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 14, weight: .medium))
                        
                        TextField("", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }

                    // PASSWORD
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 14, weight: .medium))

                        HStack {
                            Group {
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                } else {
                                    SecureField("", text: $password)
                                }
                            }
                            .foregroundColor(.white)
                            .autocapitalization(.none)

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding()
                        .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                        .cornerRadius(12)
                    }
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: LupaPasswordView()) {
                            Text("Lupa Password?")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14, weight: .medium))
                        }
                    }

                    
                }
                .padding(.horizontal, 32)


                
                // Tombol Masuk
                Button(action: handleLogin) {
                    Text("Masuk")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                
                // Error message
                if showError {
                    Text("Email atau password salah!")
                        .foregroundColor(.red)
                        .font(.system(size: 14, weight: .medium))
                }
                
                // Belum punya akun
                HStack {
                    Text("Belum punya akun?")
                        .foregroundColor(.white.opacity(0.8))
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Daftar")
                            .foregroundColor(.orange)
                            .bold()
                    }
                }
                
                Spacer()
            }
        }
    }
    
    func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            showError = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error:", error.localizedDescription)
                showError = true
                return
            }

            // LOGIN BERHASIL
            isLoggedIn = true
            userSession = result?.user.email ?? ""
        }
    }
}

#Preview {
    LoginView()
}
