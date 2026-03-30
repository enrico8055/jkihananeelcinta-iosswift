import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct ListUlangTahunView: View {
    @State private var users: [User] = []
    @State private var searchText = ""
    @State private var profileURLs: [String: URL] = [:]

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter {
                $0.fullName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    ForEach(filteredUsers) { user in
                        UserRow(
                            user: user,
                            profileURL: profileURLs[user.id],
                            age: calculateAge(from: user.dateOfBirth),
                            openWhatsApp: openWhatsApp
                        )
                    }

                    if filteredUsers.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.5))

                            Text("Tidak ada user ditemukan")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 50)
                    }

                }
                .padding(.top, 16)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 51/255, green: 51/255, blue: 51/255))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Ulang Tahun Bulan Ini")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .accentColor(.orange)
        .searchable(text: $searchText, prompt: "Cari nama")
        .onAppear {
            fetchUsers()
        }
    }
    
    struct UserRow: View {
        let user: User
        let profileURL: URL?
        let age: Int
        let openWhatsApp: (String) -> Void

        var body: some View {
            HStack(spacing: 14) {

                AsyncImage(url: profileURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure(_):
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.gray)

                    case .empty:
                        ProgressView()

                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)

                    Text("\(user.dateOfBirth) • \(age) tahun")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(user.phoneNumber) // <--- nomor telepon
                       .font(.system(size: 13))
                       .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Button {
                    openWhatsApp(user.phoneNumber)
                } label: {
                    Image(systemName: "message.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color(red: 66/255, green: 66/255, blue: 66/255))
            .cornerRadius(14)
            .shadow(
                color: Color.black.opacity(0.4),
                radius: 6,
                x: 0,
                y: 3
            )
            .padding(.horizontal, 16)
        }
    }
    
    func openWhatsApp(number: String) {
        let cleanedNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var whatsappNumber = cleanedNumber
        
        if whatsappNumber.hasPrefix("62") {
            whatsappNumber = "+62" + whatsappNumber.dropFirst(2)
        } else if whatsappNumber.hasPrefix("0") {
            whatsappNumber = "+62" + whatsappNumber.dropFirst()
        } else if !whatsappNumber.hasPrefix("62") {
            whatsappNumber = "+62" + whatsappNumber
        }
        
        let whatsappURLString = "https://wa.me/\(whatsappNumber)"
        
        guard let whatsappURL = URL(string: whatsappURLString) else {
            print("Invalid WhatsApp URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            let webURLString = "https://web.whatsapp.com/send?phone=\(whatsappNumber)"
            if let webURL = URL(string: webURLString) {
                UIApplication.shared.open(webURL)
            }
        }
    }
    
    func calculateAge(from dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")

        guard let birthDate = formatter.date(from: dateString) else {
            return 0
        }

        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        return age
    }

    func fetchUsers() {
        let ref = Database.database().reference()

        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            var tempUsers: [User] = []

            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "en_US")

            let currentMonth = Calendar.current.component(.month, from: Date())

            for child in snapshot.children {
                guard
                    let snap = child as? DataSnapshot,
                    let data = snap.value as? [String: Any]
                else { continue }

                let dateOfBirth = data["dateOfBirth"] as? String ?? ""

                if let birthDate = formatter.date(from: dateOfBirth) {
                    let birthMonth = Calendar.current.component(.month, from: birthDate)

                    if birthMonth == currentMonth {
                        let item = User(
                            id: snap.key,
                            username: data["username"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            waterBaptisteryDate: data["waterBaptisteryDate"] as? String ?? "",
                            fullName: data["fullName"] as? String ?? "",
                            nij: data["nij"] as? String ?? "",
                            gender: data["gender"] as? String ?? "",
                            placeOfBirth: data["placeOfBirth"] as? String ?? "",
                            dateOfBirth: dateOfBirth,
                            phoneNumber: data["phoneNumber"] as? String ?? "",
                            address: data["address"] as? String ?? "",
                            bloodType: data["bloodType"] as? String ?? "",
                            job: data["job"] as? String ?? "",
                            lastEducation: data["lastEducation"] as? String ?? "",
                            waterBaptism: "\(data["waterBaptism"] ?? "")",
                            waterBaptisteryChurch: data["waterBaptisteryChurch"] as? String ?? "",
                            holySpiritBaptism: "\(data["holySpiritBaptism"] ?? "")",
                            churchOrigin: data["churchOrigin"] as? String ?? "",
                            reasonToMovingChurch: data["reasonToMovingChurch"] as? String ?? "",
                            married: "\(data["married"] ?? "")",
                            fatherFullName: data["fatherFullName"] as? String ?? "",
                            motherFullName: data["motherFullName"] as? String ?? "",
                            statusInFamily: data["statusInFamily"] as? String ?? "",
                            childrenName: data["childrenName"] as? String ?? "",
                            wifeName: data["wifeName"] as? String ?? "",
                            profileImageURL: URL(string: data["profileImageURL"] as? String ?? ""),
                            husbandName: data["husbandName"] as? String ?? "",
                            siblingsName: data["siblingsName"] as? String ?? "",
                            role: data["role"] as? String ?? "Jemaat"
                        )

                        tempUsers.append(item)
                        fetchProfileImage(for: snap.key)
                    }
                }
            }

            self.users = tempUsers.sorted {
                $0.fullName < $1.fullName
            }
        }
    }
    
    func fetchProfileImage(for userId: String) {
        let storageRef = Storage.storage().reference()
            .child("\(userId)/profile-pictures")

        storageRef.downloadURL { url, error in
            if let url = url {
                DispatchQueue.main.async {
                    profileURLs[userId] = url
                }
            }
        }
    }
}
