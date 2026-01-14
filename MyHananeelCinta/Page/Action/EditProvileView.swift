import SwiftUI
import FirebaseAuth
import FirebaseDatabase


struct EditProvileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var nij: String = ""
    @State private var nama: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var noTelpon: String = ""
    @State private var jenisKelamin: String = "Laki-laki"
    @State private var tempatLahir: String = ""
    @State private var tanggalLahir: Date = Date()
    @State private var tanggalBaptisAir: Date = Date()
    @State private var alamat: String = ""
    @State private var golonganDarah: String = "A"
    @State private var pendidikan: String = "-"
    @State private var pekerjaan: String = ""
    @State private var sudahDibaptis: Bool = false
    @State private var sudahDibaptisRoh: Bool = false
    @State private var gerejaBaptis: String = ""
    @State private var asalGereja: String = ""
    @State private var alasanPindah: String = ""
    @State private var statusPernikahan: String = "Belum Menikah"
    @State private var namaIstri: String = ""
    @State private var namaAyah: String = ""
    @State private var namaIbu: String = ""
    @State private var namaAnak: String = ""
    @State private var namaSaudara: String = ""
    @State private var statusKeluarga: String = ""
    @State private var namaSuami: String = ""
    let user:User;
    @State private var currentPage: Int = 0
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
                                StyledTextField(placeholder: "NIJ", text: $nij, isDisabled: true)
                                StyledTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress, isDisabled: true)
                                StyledTextField(placeholder: "Username", text: $username)
                                
                                
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
                                StyledTextAreaView(placeholder: "Alamat", text: $alamat)
                                                    .padding()
                                
                                
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
                                StyledTextField(placeholder: "Lainnya", text: $pendidikan, isOnlyField: true)
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
                                
                                Text("Pekerjaan")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .medium))
                                StyledRadioButtonOption(title: "Pegawai Swasta", selectedOption: $pekerjaan)
                                StyledRadioButtonOption(title: "Pegawai Negeri Sipil", selectedOption: $pekerjaan)
                                StyledRadioButtonOption(title: "Profesi (Dokter, Pengacara, dll)", selectedOption: $pekerjaan)
                                StyledRadioButtonOption(title: "Fulltimer Pelayanan", selectedOption: $pekerjaan)
                                StyledTextField(placeholder: "Lainnya", text: $pekerjaan, isOnlyField: true)
                                
                                
                                Button {
                                    submitUbahProfile()
                                } label: {
                                    Text("UBAH")
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
                    Text("Detail Informasi Jemaat")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }

        }
        .accentColor(.orange)
        .onAppear(){
            //init old data
            self.nij = user.nij;
            self.nama = user.fullName;
            self.username = user.username
            self.email = user.email
            self.noTelpon = user.phoneNumber
            self.jenisKelamin = user.gender
            self.tempatLahir = user.placeOfBirth
            self.namaIstri = user.wifeName
            self.namaAnak = user.childrenName
            self.tanggalLahir = {
                let f = DateFormatter()
                f.dateFormat = "dd MMMM yyyy"
                f.locale = Locale(identifier: "en_US")
                return f.date(from: user.dateOfBirth) ?? Date()
            }()
            self.tanggalBaptisAir = {
                let f = DateFormatter()
                f.dateFormat = "dd MMMM yyyy"
                f.locale = Locale(identifier: "en_US")
                return f.date(from: user.waterBaptisteryDate) ?? Date()
            }()
            self.alamat = user.address
            self.golonganDarah = user.bloodType
            self.pendidikan = user.lastEducation
            self.pekerjaan = user.job
            self.sudahDibaptis = Bool(user.waterBaptism == "Sudah")
            self.sudahDibaptisRoh = Bool(user.holySpiritBaptism == "Sudah")
            self.gerejaBaptis = user.waterBaptisteryChurch
            self.asalGereja = user.churchOrigin
            self.alasanPindah = user.reasonToMovingChurch
            self.statusPernikahan = user.married
            self.namaAyah = user.fatherFullName
            self.namaIbu = user.motherFullName
            self.statusKeluarga = user.statusInFamily
            self.namaSuami = user.husbandName
            self.namaSaudara = user.siblingsName

        }
        .alert("Hi,", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func validasi(_ message: String) {
        showAlert = true
        alertMessage = message
        isSubmitting = false
        isLoading = false
    }
    
    func submitUbahProfile() {
        isLoading = true
        isSubmitting = true
        
        if email.isEmpty {
            validasi("Email tidak boleh kosong")
            return
        }

        if nama.isEmpty {
            validasi("Nama lengkap wajib diisi")
            return
        }

        if username.isEmpty {
            validasi("Username wajib diisi")
            return
        }

        if noTelpon.isEmpty {
            validasi("Nomor telepon wajib diisi")
            return
        }
        
        if noTelpon.hasPrefix("+") {
            let numberPart = String(noTelpon.dropFirst())

            if numberPart.isEmpty || !numberPart.allSatisfy({ $0.isNumber }) {
                validasi("Nomor telepon hanya boleh berisi angka dan satu tanda '+' di depan")
                return
            }
        } else {
            if !noTelpon.allSatisfy({ $0.isNumber }) {
                validasi("Nomor telepon hanya boleh berisi angka")
                return
            }
        }


        if noTelpon.count > 16 {
            validasi("Nomor telepon maksimal 16 digit")
            return
        }

        if jenisKelamin.isEmpty {
            validasi("Jenis kelamin wajib dipilih")
            return
        }

        if tempatLahir.isEmpty {
            validasi("Tempat lahir wajib diisi")
            return
        }

        if alamat.isEmpty {
            validasi("Alamat wajib diisi")
            return
        }

        if golonganDarah.isEmpty {
            validasi("Golongan darah wajib dipilih")
            return
        }

        if pendidikan.isEmpty {
            validasi("Pendidikan terakhir wajib diisi")
            return
        }

        if pekerjaan.isEmpty {
            validasi("Pekerjaan wajib diisi")
            return
        }

        if statusPernikahan.isEmpty {
            validasi("Status pernikahan wajib dipilih")
            return
        }

        if namaAyah.isEmpty {
            validasi("Nama ayah wajib diisi")
            return
        }

        if namaIbu.isEmpty {
            validasi("Nama ibu wajib diisi")
            return
        }

        if statusKeluarga.isEmpty {
            validasi("Status dalam keluarga wajib dipilih")
            return
        }

        if sudahDibaptis && gerejaBaptis.isEmpty {
            validasi("Nama gereja baptis wajib diisi")
            return
        }

        if !asalGereja.isEmpty && alasanPindah.isEmpty {
            validasi("Alasan pindah gereja wajib diisi")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()

        let f = DateFormatter()
        f.dateFormat = "dd MMMM yyyy"
        f.locale = Locale(identifier: "en_US")
        
        let tanggalLahirStr = f.string(from: self.tanggalLahir)
        let tanggalBaptisAirStr = f.string(from: self.tanggalBaptisAir)

        let updateData: [String: Any] = [
            "fullName": self.nama,
            "username": self.username,
            "phoneNumber": self.noTelpon.hasPrefix("0")
                ? "+62" + String(self.noTelpon.dropFirst())
                : self.noTelpon,
            "gender": self.jenisKelamin,
            "placeOfBirth": self.tempatLahir,
            "dateOfBirth": tanggalLahirStr,
            "waterBaptisteryDate": tanggalBaptisAirStr,
            "address": self.alamat,
            "bloodType": self.golonganDarah,
            "lastEducation": self.pendidikan,
            "job": self.pekerjaan,
            "wifeName": self.namaIstri,
            "childrenName" : self.namaAnak,
            "waterBaptism": self.sudahDibaptis ? true : false,
            "waterBaptisteryChurch": self.gerejaBaptis,
            "holySpiritBaptism": self.sudahDibaptisRoh ? true : false,
            "churchOrigin": self.asalGereja,
            "reasonToMovingChurch": self.alasanPindah,
            "married": self.statusPernikahan == "Belum Menikah" ? false : true,
            "fatherFullName": self.namaAyah,
            "motherFullName": self.namaIbu,
            "statusInFamily": self.statusKeluarga,
            "husbandName": self.namaSuami,
            "siblingsName" : self.namaSaudara
        ]
        

        ref.child("users").child(uid).updateChildValues(updateData) { error, _ in
            DispatchQueue.main.async {
                if let error = error {
                    showAlert = true;
                    alertMessage = "Gagal submit: \(error.localizedDescription)"
                    isSubmitting = false
                    isLoading = false
                } else {
                    showAlert = true;
                    alertMessage = "Berhasil update profile!"
                    dismiss()
                    isLoading = false
                }
            }
        }
    }


}



#Preview {
    RegisterView()
}
