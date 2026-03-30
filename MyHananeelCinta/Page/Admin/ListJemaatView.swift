import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct ListJemaatView: View {
    @State private var users: [User] = []
    @State private var searchText = ""
    @State private var profileURLs: [String: URL] = [:]
    @State private var hasFetched = false
    @State private var isLoading = false
    @State private var lastKey: String? = nil
    @State private var hasMore = true
    
    let pageSize = 20  // load 20 user per batch

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
                        .onAppear {
                            // Kalau user ini adalah yang terakhir, load batch berikutnya
                            if user.id == filteredUsers.last?.id && searchText.isEmpty {
                                fetchUsers()
                            }
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .padding(.vertical, 16)
                    }
                    
                    if filteredUsers.isEmpty && !isLoading {
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
                    
                    if !hasMore && !users.isEmpty && searchText.isEmpty {
                        Text("Semua jemaat sudah ditampilkan")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.vertical, 12)
                    }
                }
                .padding(.top, 16)
                .frame(maxWidth: .infinity)
            }
            .background(Color(red: 51/255, green: 51/255, blue: 51/255))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Jemaat")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .accentColor(.orange)
        .searchable(text: $searchText, prompt: "Cari nama")
        .onAppear {
            guard !hasFetched else { return }
            hasFetched = true
            fetchUsers()
        }
    }
    
    // MARK: - User Row
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
                    
                    Text(user.phoneNumber)
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
            .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 3)
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Fetch Users (Pagination)
    func fetchUsers() {
        guard !isLoading && hasMore else { return }
        isLoading = true
        
        let ref = Database.database().reference().child("users")
        var query = ref.queryOrderedByKey().queryLimited(toFirst: UInt(pageSize + 1))
        
        // Kalau sudah ada lastKey, mulai dari sana
        if let lastKey = lastKey {
            query = ref.queryOrderedByKey()
                .queryStarting(afterValue: lastKey)
                .queryLimited(toFirst: UInt(pageSize + 1))
        }
        
        query.observeSingleEvent(of: .value) { snapshot in
            var tempUsers: [User] = []
            
            for child in snapshot.children {
                guard
                    let snap = child as? DataSnapshot,
                    let data = snap.value as? [String: Any]
                else { continue }
                
                let user = User(
                    id: snap.key,
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    waterBaptisteryDate: data["waterBaptisteryDate"] as? String ?? "",
                    fullName: data["fullName"] as? String ?? "",
                    nij: data["nij"] as? String ?? "",
                    gender: data["gender"] as? String ?? "",
                    placeOfBirth: data["placeOfBirth"] as? String ?? "",
                    dateOfBirth: data["dateOfBirth"] as? String ?? "",
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
                tempUsers.append(user)
            }
            
            // Kalau dapat pageSize+1, berarti masih ada data
            if tempUsers.count > pageSize {
                tempUsers.removeLast()
                hasMore = true
            } else {
                hasMore = false
            }
            
            lastKey = tempUsers.last?.id
            
            let sorted = tempUsers.sorted { $0.fullName < $1.fullName }
            users.append(contentsOf: sorted)
            
            // Fetch profile image hanya untuk batch ini
            for user in sorted {
                fetchProfileImage(for: user.id)
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Fetch Profile Image
    func fetchProfileImage(for userId: String) {
        guard profileURLs[userId] == nil else { return }

        if let user = users.first(where: { $0.id == userId }),
           let existingURL = user.profileImageURL {
            DispatchQueue.main.async {
                profileURLs[userId] = existingURL
            }
            return
        }

        let storageRef = Storage.storage().reference()
            .child("\(userId)/profile-pictures")

        storageRef.downloadURL { url, _ in
            if let url = url {
                DispatchQueue.main.async {
                    profileURLs[userId] = url
                }
            }
        }
    }
    
    // MARK: - Open WhatsApp
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
        
        guard let whatsappURL = URL(string: whatsappURLString) else { return }
        
        if UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            let webURLString = "https://web.whatsapp.com/send?phone=\(whatsappNumber)"
            if let webURL = URL(string: webURLString) {
                UIApplication.shared.open(webURL)
            }
        }
    }
    
    // MARK: - Calculate Age
    func calculateAge(from dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")

        guard let birthDate = formatter.date(from: dateString) else { return 0 }

        return Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }
}
