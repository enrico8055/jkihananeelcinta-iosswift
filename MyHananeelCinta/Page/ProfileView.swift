import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct ProfileView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false;
    @State private var showAboutAlert: Bool = false;
    @State private var users: [User] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 51/255, green: 51/255, blue: 51/255)
                    .ignoresSafeArea()
                ScrollView {
                    if let user = users.first {
                        VStack(spacing: 24) {
                            
                            
                            VStack(spacing: 12) {
                                
                                if let url = user.profileImageURL ?? nil {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                            
                                        case .failure:
                                            //template gagal ambil gambar
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.white.opacity(0.9))
                                        @unknown default:
                                            //template gagal ambil gambar
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                } else {
                                    //template gagal ambil gambar
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                
                            }
                            .padding(.top, 0)
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                            .frame(width: 100, height: 100)
                            
                            //nama
                            Text(user.fullName)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                            //detail
                            VStack(spacing: 16) {
                                profileRow("Nomor Induk Jemaat", user.nij)
                                profileRow("Jenis Kelamin", user.gender)
                                profileRow("Tempat Lahir", user.placeOfBirth)
                                profileRow("Tanggal Lahir", user.dateOfBirth)
                                profileRow("No. Handphone", user.phoneNumber)
                                profileRow("Alamat", user.address)
                                profileRow("Golongan Darah", user.bloodType)
                                profileRow("Pendidikan", user.lastEducation)
                                profileRow("Pekerjaan", user.job)
                                profileRow("Sudah Dibaptis Air?", user.waterBaptism)
                                profileRow("Gereja Tempat Baptis", user.waterBaptisteryChurch)
                                profileRow("Sudah Baptis Roh Kudus?", user.holySpiritBaptism)
                                profileRow("Asal Gereja (bila pindah gereja)", user.churchOrigin)
                                profileRow("Alasan Pindah Gereja", user.reasonToMovingChurch)
                                profileRow("Status Pernikahan", user.married)
                                profileRow("Nama Lengkap Ayah", user.fatherFullName)
                                profileRow("Nama Lengkap Ibu", user.motherFullName)
                                profileRow("Status Dalam Keluarga", user.statusInFamily)
                                
                                
                            }
                            .padding(20)
                            .background(
                                Color(red: 66/255, green: 66/255, blue: 66/255)
                            )
                            .cornerRadius(16)
                            
                            VStack(spacing: 0) {
                                
                                //ubah profile
                                NavigationLink {
                                    EditProvileView(user: user)
                                    
                                } label: {
                                    HStack {
                                        Text("Ubah")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    .padding()
                                    .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                                    .cornerRadius(12)
                                    
                                }
                                
                                //tentang app
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Text("Tentang Aplikasi")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    .padding()
                                    .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        showAboutAlert = true
                                    }
                                    .alert("Tentang Aplikasi", isPresented: $showAboutAlert) {
                                        Button("OK", role: .cancel) { }
                                    } message: {
                                        Text("Versi 1.0.0.0\nMy Hananeel Cinta\nDikembangkan oleh Tim JKI Hananeel Cinta")
                                    }
                                    
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.15))
                                
                                //logout
                                Button {
                                    do {
                                        try Auth.auth().signOut()
                                        isLoggedIn = false
                                    } catch {
                                        print("Logout error: \(error.localizedDescription)")
                                    }
                                } label: {
                                    HStack {
                                        Text("Logout")
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                            .background(
                                Color(red: 66/255, green: 66/255, blue: 66/255)
                            )
                            .cornerRadius(16)
                            .padding(.horizontal, 0)
                            
                            Spacer(minLength: 24)
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Detail Informasi Jemaat")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                if isLoading {
                    LoadingOverlayView()
                }
            }
            
        }
        .accentColor(.orange)
        .onAppear(){
            fetchUserData()
        }
    }
    
    //get data user
    func fetchUserData() {
        isLoading = true;
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoggedIn = false
            return
        }

        let ref2 = Database.database().reference().child("users").child(uid)
        ref2.getData { error, snapshot in
            if let data = snapshot?.value as? [String: Any] {

                let refs = Storage.storage().reference()
                    .child(uid)
                    .child("profile-pictures")

                refs.downloadURL { url, error in
                    DispatchQueue.main.async {

                        let user = User(
                            id: uid,
                            username: data["username"] as? String ?? "-",
                            email: data["email"] as? String ?? "-",
                            waterBaptisteryDate: data["waterBaptisteryDate"] as? String ?? "-",
                            fullName: data["fullName"] as? String ?? "-",
                            nij: data["nij"] as? String ?? "-",
                            gender: data["gender"] as? String ?? "-",
                            placeOfBirth: data["placeOfBirth"] as? String ?? "-",
                            dateOfBirth: data["dateOfBirth"] as? String ?? "-",
                            phoneNumber: data["phoneNumber"] as? String ?? "-",
                            address: data["address"] as? String ?? "-",
                            bloodType: data["bloodType"] as? String ?? "-",
                            job: data["job"] as? String ?? "-",
                            lastEducation: data["lastEducation"] as? String ?? "-",
                            waterBaptism: ((data["waterBaptism"] as? Bool ?? false) || (data["waterBaptism"] as? String == "true")) ? "Sudah" : "Belum",
                            waterBaptisteryChurch: data["waterBaptisteryChurch"] as? String ?? "-",
                            holySpiritBaptism: ((data["holySpiritBaptism"] as? Bool ?? false) || (data["holySpiritBaptism"] as? String == "true")) ? "Sudah" : "Belum",
                            churchOrigin: data["churchOrigin"] as? String ?? "-",
                            reasonToMovingChurch: data["reasonToMovingChurch"] as? String ?? "-",
                            married: (data["married"] as? Bool ?? false) ? "Menikah" : "Belum Menikah",
                            fatherFullName: data["fatherFullName"] as? String ?? "-",
                            motherFullName: data["motherFullName"] as? String ?? "-",
                            statusInFamily: data["statusInFamily"] as? String ?? "-",
                            profileImageURL: url
                        )

                        self.users = [user]
                        
                        isLoading = false;
                    }
                }
            }
        }
    }
    
    
    
    //generate ui list detail
    private func profileRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 140, alignment: .leading)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }
}

