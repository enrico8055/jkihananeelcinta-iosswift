import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct LupaPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var currentPage: Int = 0
    @State private var showAlert: Bool = false;
    @State private var alertMessage: String = "";
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 51/255, green: 51/255, blue: 51/255)
                    .ignoresSafeArea()
                
                TabView(selection: $currentPage) {
                    
                    // STEP 1
                    ScrollView {
                        VStack(spacing: 16) {
                            StyledTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                        }
                        .padding()
                        .background(CardBackground())
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        Button {
                            submitLupaPassword()
                        } label: {
                            Text("RESET PASSWORD")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }.padding()
                    }
                    .tag(0)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Reset Password")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }

        }
        .accentColor(.orange)
        .alert("Hi,", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func submitLupaPassword() {
        guard !email.isEmpty  else {
            showAlert = true;
            alertMessage = "Email harus diisi"
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                showAlert = true;
                alertMessage = "Gagal reset password: \(error.localizedDescription)"
            } else {
                showAlert = true;
                alertMessage = "Email untuk mereset password berhasil dikirim, cek spam jika tidak ditemukan"
                email = ""
            }
        }

        
        
    }
    
    
}



#Preview {
}
