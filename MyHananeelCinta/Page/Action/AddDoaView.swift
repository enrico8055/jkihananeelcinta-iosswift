import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct AddDoaView: View {
    var userName: String
    @Environment(\.dismiss) var dismiss
    @State private var prayType: String = "Bantuan Doa"
    @State private var prayDesc: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var currentPage: Int = 0
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 51/255, green: 51/255, blue: 51/255)
                    .ignoresSafeArea()
                
                TabView(selection: $currentPage) {
                    
                    // STEP 1
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Jenis Permintaan Doa")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                            Picker("", selection: $prayType) {
                                Text("Kunjungan").tag("Kunjungan")
                                Text("Bantuan Doa").tag("Bantuan Doa")
                                Text("Konseling").tag("Konseling")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            StyledTextAreaView(placeholder: "Isi Doa", text: $prayDesc)
                                                .padding()
                            
                            Button {
                                submitPrayerRequest()
                            } label: {
                                Text("SUBMIT")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(CardBackground())
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    .tag(0)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Buat Permintaan Doa")
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
    
    func submitPrayerRequest() {
        isSubmitting = true
        
        guard
            !prayType.isEmpty,
            !prayDesc.isEmpty
        else {
            showAlert = true;
            alertMessage = "Error data kurang lengkap"
            isSubmitting = false
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert = true;
            alertMessage = "Error UID tidak ditemukan"
            isSubmitting = false
            return
        }

        let ref = Database.database().reference()
        
        let autoId = "\(Int(Date().timeIntervalSince1970 * 1000))"
        
        let prayerData: [String: Any] = [
            "requesterId": uid,
            "prayDesc": prayDesc,
            "prayType": prayType,
            "handlerId": "",
            "handlerName": "",
            "id": autoId,
            "status": "OPEN",
            "prayResult": "",
            "requesterName": userName
        ]
        
        ref.child("prayerRequest").child(autoId).setValue(prayerData) { error, _ in
            DispatchQueue.main.async {
                if let error = error {
                    showAlert = true;
                    alertMessage = "Error submit: \(error.localizedDescription)"
                    isSubmitting = false
                } else {
                    showAlert = true;
                    alertMessage = "Berhasil submit doa, Tuhan memberkati"
                    isSubmitting = false
                    dismiss()
                }
            }
        }
    }
}


#Preview {
}
