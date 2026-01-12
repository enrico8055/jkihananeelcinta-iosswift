import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false;
    @State private var isLoading = false
    @State private var nama: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var noTelpon: String = ""
    @State private var jenisKelamin: String = "Laki-laki"
    @State private var tempatLahir: String = ""
    @State private var tanggalLahir: Date = Date()
    @State private var tanggalBaptisAir: Date = Date()
    @State private var alamat: String = ""
    @State private var golonganDarah: String = "A"
    @State private var pendidikan: String = "SD"
    @State private var pekerjaan: String = ""
    @State private var sudahDibaptis: Bool = false
    @State private var sudahDibaptisRoh: Bool = false
    @State private var gerejaBaptis: String = ""
    @State private var asalGereja: String = ""
    @State private var alasanPindah: String = ""
    @State private var statusPernikahan: String = "Belum Menikah"
    @State private var namaAyah: String = ""
    @State private var namaIbu: String = ""
    @State private var namaIstri: String = ""
    @State private var namaAnak: String = ""
    @State private var namaSuami: String = ""
    @State private var namaSaudara: String = ""
    @State private var statusKeluarga: String = "Anak"
    @State private var currentPage: Int = 0
    @State private var profileImage: UIImage? = nil
    @State private var showAlert: Bool = false;
    @State private var alertMessage: String = "";
    @State private var isSubmitting = false

    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 51/255, green: 51/255, blue: 51/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress bar
                    VStack(spacing: 8) {
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 4)
                                
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: geometry.size.width * CGFloat(currentPage + 1) / 6, height: 4)
                            }
                        }
                        .frame(height: 4)
                        
                        // Label step
                        Text("Step \(currentPage + 1) dari 6")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    TabView(selection: $currentPage) {
                        
                        // STEP 1
                        ScrollView {
                            VStack(spacing: 16) {
                                ProfileImagePickerCamera(image: $profileImage)
                                StyledTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                                StyledTextField(placeholder: "Username", text: $username)
                                StyledSecureField(placeholder: "Password", text: $password)
                                
                                
                            }
                            .padding()
                            .background(CardBackground())
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .tag(0)
                        
                        // STEP 2
                        ScrollView {
                            VStack(spacing: 16) {
                                StyledTextField(placeholder: "Nama Lengkap", text: $nama)
                                Text("Jenis Kelamin")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                Picker("", selection: $jenisKelamin) {
                                    Text("Laki-laki").tag("Laki-laki")
                                    Text("Perempuan").tag("Perempuan")
                                }.pickerStyle(SegmentedPickerStyle())
                                StyledTextField(placeholder: "Tempat Lahir", text: $tempatLahir)
                                Text("Tanggal Lahir")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                StyledDatePicker(label: "Tanggal Lahir", selection: $tanggalLahir)
                                StyledTextField(placeholder: "Nomor Handphone", text: $noTelpon, keyboardType: .phonePad)
                                
                            }
                            .padding()
                            .background(CardBackground())
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .tag(1)
                        
                        // STEP 3
                        ScrollView {
                            VStack(spacing: 16) {
                                StyledTextField(placeholder: "Alamat", text: $alamat)
                                
                                
                            }
                            .padding()
                            .background(CardBackground())
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .tag(2)
                        
                        // STEP 4
                        ScrollView {
                            VStack(spacing: 16) {
                                
                                Text("Golongan Darah")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                Picker("", selection: $golonganDarah) {
                                    Text("A").tag("A")
                                    Text("B").tag("B")
                                    Text("AB").tag("AB")
                                    Text("O").tag("O")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                
                                Text("Pendidikan Terakhir")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                StyledRadioButtonOption(title: "SD", selectedOption: $pendidikan)
                                StyledRadioButtonOption(title: "SMP", selectedOption: $pendidikan)
                                StyledRadioButtonOption(title: "SMA", selectedOption: $pendidikan)
                                StyledRadioButtonOption(title: "D1,D2,D3", selectedOption: $pendidikan)
                                StyledRadioButtonOption(title: "S1", selectedOption: $pendidikan)
                                StyledRadioButtonOption(title: "S2", selectedOption: $pendidikan)
                                StyledRadioButtonOption(title: "S3", selectedOption: $pendidikan)
                            }
                            .padding()
                            .background(CardBackground())
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .tag(3)
                        
                        
                        // STEP 4
                        ScrollView {
                            VStack(spacing: 16) {
                                
                                Toggle(isOn: $sudahDibaptis) {
                                    Text("Sudah Baptis Air?")
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .orange))
                                .padding()
                                .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                                .cornerRadius(12)
                                
                                StyledTextField(placeholder: "Gereja Tempat Baptis Air", text: $gerejaBaptis)
                                
                                Text("Kapan Baptis Air?")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                StyledDatePicker(label: "Tanggal Baptis Air", selection: $tanggalBaptisAir)
                                
                                Toggle(isOn: $sudahDibaptisRoh) {
                                    Text("Sudah Baptis Roh Kudus?")
                                        .foregroundColor(.white)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .orange))
                                .padding()
                                .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                                .cornerRadius(12)
                                
                                
                                StyledTextField(placeholder: "Asal Gereja (bila pindah gereja)", text: $asalGereja)
                                
                                StyledTextField(placeholder: "Alasan Pindah Gereja", text: $alasanPindah)
                                
                                
                            }
                            .padding()
                            .background(CardBackground())
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .tag(4)
                        
                        // STEP 5
                        ScrollView {
                            VStack(spacing: 16) {
                                
                                
                                
                                Text("Status Pernikahan")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                Picker("", selection: $statusPernikahan) {
                                    Text("Belum Menikah").tag("Belum Menikah")
                                    Text("Menikah").tag("Menikah")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                
                                Text("Status Dalam Keluarga")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                StyledRadioButtonOption(title: "Kepala Keluarga", selectedOption: $statusKeluarga)
                                StyledRadioButtonOption(title: "Istri", selectedOption: $statusKeluarga)
                                StyledRadioButtonOption(title: "Anak", selectedOption: $statusKeluarga)
                                StyledRadioButtonOption(title: "Janda", selectedOption: $statusKeluarga)
                                StyledRadioButtonOption(title: "Duda", selectedOption: $statusKeluarga)
                                
                                if statusKeluarga == "Kepala Keluarga" {
                                    StyledTextField(placeholder: "Nama Istri", text: $namaIstri)
                                }
                                
                                if (statusKeluarga == "Kepala Keluarga" || statusKeluarga == "Istri") {
                                    StyledTextField(placeholder: "Nama Anak", text: $namaAnak)
                                }
                                
                                if statusKeluarga == "Istri" {
                                    StyledTextField(placeholder: "Nama Suami", text: $namaSuami)
                                }
                                
                                if statusKeluarga == "Anak" {
                                    StyledTextField(placeholder: "Nama Saudara", text: $namaSaudara)
                                }
                                
                                StyledTextField(placeholder: "Nama Lengkap Ayah", text: $namaAyah)
                                
                                StyledTextField(placeholder: "Nama Lengkap Ibu", text: $namaIbu)
                                
                                StyledTextField(placeholder: "Pekerjaan", text: $pekerjaan)
                                
                                
                                Button {
                                    submitRegister()
                                } label: {
                                    Text("DAFTAR")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .cornerRadius(12)
                                }.disabled(isSubmitting)
                                
                                
                            }
                            .padding()
                            .background(CardBackground())
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .tag(5)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                if isLoading {
                    LoadingOverlayView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pendaftaran Jemaat Baru")
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
    
    func submitRegister() {
        isLoading = true
        isSubmitting = true
        guard
            !email.isEmpty,
            !password.isEmpty,
            profileImage != nil,
            !nama.isEmpty,
            !username.isEmpty,
            !noTelpon.isEmpty,
            !jenisKelamin.isEmpty,
            !tempatLahir.isEmpty,
            !alamat.isEmpty,
            !golonganDarah.isEmpty,
            !pendidikan.isEmpty,
            !pekerjaan.isEmpty,
            !statusPernikahan.isEmpty,
            !namaAyah.isEmpty,
            !namaIbu.isEmpty,
            !statusKeluarga.isEmpty,
            !(sudahDibaptis && gerejaBaptis.isEmpty),
            !(!asalGereja.isEmpty && alasanPindah.isEmpty)
        else {
            showAlert = true;
            alertMessage = "Error data kurang lengkap"
            isSubmitting = false
            isLoading = false
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    showAlert = true;
                    alertMessage = "Error register: \(error.localizedDescription)"
                    isSubmitting = false
                    isLoading = false
                    return
                }
                
                // Ambil uid user yang baru dibuat
                guard let uid = result?.user.uid else {
                    showAlert = true;
                    alertMessage = "Error UID tidak ditemukan"
                    isSubmitting = false
                    isLoading = false
                    return
                }
                
                if let image = profileImage {
                    uploadProfileImage(image: image, userId: uid) { url in
                        if let url = url {
                            let ref = Database.database().reference().child("users")

                            ref.observeSingleEvent(of: .value) { snapshot in
                                let userCount = Int(snapshot.childrenCount)
                                let nextIndex = userCount + 1
                                let formattedNumber = String(format: "%05d", nextIndex)
                                let nij = "HC-\(formattedNumber)"
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd MMMM yyyy"
                                formatter.locale = Locale(identifier: "en_US")
                                let tanggalLahirStr = formatter.string(from: self.tanggalLahir)
                                let tanggalBaptisAirStr = formatter.string(from: self.tanggalBaptisAir)
                                
                                // Data profil
                                let userData: [String: Any] = [
                                    "nij":nij,
                                    "addressLat": 0,
                                    "addressLong": 0,
                                    "email": self.email,
                                    "headOfFamilyId": "",
                                    "fcmToken": "",
                                    "password": "",
                                    "photoImageUrl": url.path(),
                                    "role": "Jemaat",
                                    "childrenName": self.namaAnak,
                                    "fullName": self.nama,
                                    "username": self.username,
                                    "phoneNumber": self.noTelpon,
                                    "gender": self.jenisKelamin,
                                    "placeOfBirth": self.tempatLahir,
                                    "dateOfBirth": tanggalLahirStr,
                                    "waterBaptisteryDate": tanggalBaptisAirStr,
                                    "address": self.alamat,
                                    "bloodType": self.golonganDarah,
                                    "lastEducation": self.pendidikan,
                                    "job": self.pekerjaan,
                                    "id":uid,
                                    "waterBaptism": self.sudahDibaptis ? true : false,
                                    "waterBaptisteryChurch": self.gerejaBaptis,
                                    "holySpiritBaptism": self.sudahDibaptisRoh ? true : false,
                                    "churchOrigin": self.asalGereja,
                                    "reasonToMovingChurch": self.alasanPindah,
                                    "wifeName": self.namaIstri,
                                    "married": self.statusPernikahan == "Belum Menikah" ? false : true,
                                    "fatherFullName": self.namaAyah,
                                    "motherFullName": self.namaIbu,
                                    "platform": "IOS",
                                    "statusInFamily": self.statusKeluarga,
                                    "husbandName": self.namaSuami,
                                    "siblingsName" : self.namaSaudara
                                ]
                                
                                // Insert ke Realtime Database
                                let ref = Database.database().reference()
                                ref.child("users").child(uid).setValue(userData) { error, _ in
                                    DispatchQueue.main.async {
                                        if let error = error {
                                            showAlert = true;
                                            alertMessage = "Error menyimpan data user: \(error.localizedDescription)"
                                            isSubmitting = false
                                            isLoading = false
                                        } else {
                                            showAlert = true;
                                            alertMessage = "Berhasil register, selamat datang di My Hananeel Cinta"
                                            isLoggedIn = true;
                                            isSubmitting = false
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func uploadProfileImage(image: UIImage, userId: String, completion: @escaping (URL?) -> Void) {
        // Convert UIImage ke Data (JPEG)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert = true;
            alertMessage = "Error convert image ke data"
            isSubmitting = false
            completion(nil)
            isLoading = false
            return
        }
        
        // Reference ke Storage -> folder userId / profile-pictures.jpg
        let storageRef = Storage.storage().reference()
            .child("\(userId)/profile-pictures")
        
        // Upload data
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                showAlert = true;
                alertMessage = "Error upload image: \(error.localizedDescription)"
                isSubmitting = false
                completion(nil)
                isLoading = false
                return
            }
            
            // Ambil download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    showAlert = true;
                    alertMessage = "Error ambil URL: \(error.localizedDescription)"
                    isSubmitting = false
                    completion(nil)
                    isLoading = false
                    return
                }
                
                
                completion(url)
            }
        }
    }


}



#Preview {
}
