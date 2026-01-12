
import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct HomeView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isLoading = false
    @State private var announcements: [Announcement] = []
    @State private var renungans: [Renungan] = []
    @State private var mks: [MK] = []
    @State private var users: [User] = []
    
    

    
    var body: some View {
        ZStack {
            Color(red: 51/255, green: 51/255, blue: 51/255)
                .ignoresSafeArea()
            
            ScrollView {
                // header
                HStack {
                    
                    //greeting
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hi,")
                            .foregroundColor(
                                Color(red: 242/255, green: 219/255, blue: 204/255)
                            )
                            .font(.system(size: 24, weight: .semibold, design: .default))
                        Text(users.first?.fullName ?? "-")
                            .foregroundColor(
                                Color(red: 242/255, green: 219/255, blue: 204/255)
                            )
                            .font(.system(size: 24, weight: .semibold, design: .default))
                    }
                    
                    Spacer()
                    
                    //profile image
                    NavigationLink {
                        ProfileView()
                    } label: {
                        ZStack {
                            if let url = users.first?.profileImageURL ?? nil {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                        
                                    case .failure:
                                        //template gagal ambil gambar
                                        Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.white)
                                    @unknown default:
                                        //template gagal ambil gambar
                                        Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.white)
                                    }
                                }
                            } else {
                                //template gagal ambil gambar
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.orange, lineWidth: 2)
                        )
                        .frame(width: 60, height: 60)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                
                // renungan harian
                if let firstRenungan = renungans.first {
                    VStack(alignment: .leading, spacing: 12) {
                        // Label Kecil di Atas
                        HStack {
                            Image(systemName: "sun.max.fill")
                            Text("RENUNGAN HARIAN")
                                .font(.system(size: 10, weight: .bold))
                                .kerning(1.2)
                        }
                        .foregroundColor(.black.opacity(0.8))
                        
                        // Judul
                        Text(firstRenungan.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .lineLimit(1)
                    
                        // Ayat / isi teks
                        Text(String(firstRenungan.messages.prefix(200)) + "...")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.9))
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                        
                        // Footer (Tombol Baca)
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: RenunganView(renungan: firstRenungan)) {
                                HStack(spacing: 4) {
                                    Text("Baca Selengkapnya")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.system(size: 13, weight: .bold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [.orange, Color(red: 1.0, green: 0.55, blue: 0.0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .shadow(
                        color: Color.orange.opacity(0.3),
                        radius: 10,
                        x: 0,
                        y: 5
                    )
                }
                
                
                // judul pengumuman
                HStack {
                    Text("Pengumuman") .font(.system(size: 24, weight: .semibold)) .foregroundColor(
                        Color(red: 242/255, green: 219/255, blue: 204/255)
                    )
                    .padding()
                    Spacer()
                }
                
                
                //slider gambar pengumuman
                TabView {
                    ForEach(announcements) { item in
                        NavigationLink(destination: PengumumanView(announcement: item)) {
                            
                            AsyncImage(url: URL(string: item.imageUrl)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                    
                                case .failure(_):
                                    Color.gray
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundColor(.white.opacity(0.7))
                                        )
                                    
                                default:
                                    ProgressView()
                                }
                            }
                            .frame(height: 220)
                            .clipped()
                        }
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
                .tabViewStyle(PageTabViewStyle())
                .shadow(
                    color: Color.black.opacity(0.4),
                    radius: 6,
                    x: 0,
                    y: 3
                )
                
                
                
                // judul Menu
                HStack {
                    Text("Menu") .font(.system(size: 24, weight: .semibold)) .foregroundColor(
                        Color(red: 242/255, green: 219/255, blue: 204/255)
                    )
                    
                    
                    .padding()
                    Spacer()
                }
                
                
                
                //button menu
                let buttons = [
                    "Ibadah", "Permintaan Doa", "Renungan",
                    "Persembahan"
                ]
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3),
                    spacing: 0
                ) {
                    ForEach(buttons, id: \.self) { title in
                        
                        NavigationLink {
                            if (title == "Persembahan") {
                                PersembahanView()
                            }else if (title == "Renungan") {
                                    ListRenunganView(renungans: renungans)
                            }else if (title == "Ibadah") {
                                ListIbadahView(mks:mks)
                            } else if (title == "Permintaan Doa") {
                                ListDoaView( userName: users.first?.fullName ?? "-")
                            } else {
                            }
                        } label: {
                            

                            VStack(spacing: 12) {
                                var iconName: String {
                                    switch title {
                                    case "Ibadah": return "house.fill"
                                    case "Permintaan Doa": return "bird.fill"
                                    case "Renungan": return "book.closed.fill"
                                    case "Persembahan": return "heart.fill"
                                    default: return "leaf.fill"
                                    }
                                }

                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color(red: 45/255, green: 45/255, blue: 48/255))
                                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)

                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.15), .clear],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )

                                    Circle()
                                        .fill(Color.orange.opacity(0.08))
                                        .frame(width: 55, height: 55)

                                    Image(systemName: iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.orange)
                                        .shadow(color: Color.orange.opacity(0.4), radius: 6, x: 0, y: 0)
                                }
                                .frame(height: 100)

                                Text(title)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(height: 35, alignment: .top)
                            }
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .padding()
                    
                    
                    
                    
                    
                }
            }
            
            if isLoading {
                LoadingOverlayView()
            }
            
        }.onAppear(){
            fetchUserData()
            fetchRenungans()
            fetchAnnouncementData()
            fetchMks()
        }
    }
    
    //get data user
    func fetchUserData() {
        isLoading = true;
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false;
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

    
    //get data pengumuman
    func fetchAnnouncementData() {
        let ref = Database.database().reference()
        
        ref.child("announcement")
            .observeSingleEvent(of: .value) { snapshot in
                
                var tempData: [Announcement] = []
                
                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let data = snap.value as? [String: Any] {
                        
                        let item = Announcement(
                            id: snap.key,
                            title: data["title"] as? String ?? "-",
                            desc: data["desc"] as? String ?? "-",
                            date: data["date"] as? String ?? "-",
                            imageUrl: data["imageUrl"] as? String ?? "-",
                            infoUrl: data["infoUrl"] as? String ?? "-",
                            contactPerson: data["contactPerson"] as? String ?? "-",
                            contactPersonName: data["contactPersonName"] as? String ?? "-"
                        )
                        
                        tempData.append(item)
                    }
                }
                
                DispatchQueue.main.async {
                    self.announcements = tempData
                }
            }
    }

    
    //get data renungan harian
    func fetchRenungans() {
        let ref = Database.database().reference()
        
        ref.child("pastorMessages")
            .queryOrderedByKey()
            .queryLimited(toLast: 30)
            .observeSingleEvent(of: .value) { snapshot in

                var tempRenungans: [Renungan] = []

                for child in snapshot.children {
                    guard
                        let snap = child as? DataSnapshot,
                        let data = snap.value as? [String: Any]
                    else { continue }
                    
                    let dateString: String
                    if let timestamp = data["date"] as? Double {
                        let dateObj = Date(timeIntervalSince1970: timestamp / 1000)
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        dateString = formatter.string(from: dateObj)
                    } else if let str = data["date"] as? String {
                        dateString = str
                    } else {
                        dateString = "-"
                    }

                    let item = Renungan(
                        id: snap.key,
                        title: data["title"] as? String ?? "-",
                        writer: data["writer"] as? String ?? "-",
                        messages: data["messages"] as? String ?? "-",
                        date: dateString
                    )
                    
                    


                    tempRenungans.append(item)
                }
                
                tempRenungans.sort { $0.id > $1.id }

                self.renungans = tempRenungans
            }
    }
    
    //get data
    func fetchMks() {
        let ref = Database.database().reference()
        
        ref.child("mk")
            .queryOrderedByKey()
            .queryLimited(toLast: 50)
            .observeSingleEvent(of: .value) { snapshot in

                var tempMks: [MK] = []

                for child in snapshot.children {
                    guard
                        let snap = child as? DataSnapshot,
                        let data = snap.value as? [String: Any]
                    else { continue }

                    let item = MK(
                        id: snap.key,
                        contact: data["contact"] as? String ?? "-",
                        day: data["day"] as? String ?? "-",
                        desc: data["desc"] as? String ?? "-",
                        location: data["location"] as? String ?? "-",
                        pic: data["pic"] as? String ?? "-",
                        time: data["time"] as? String ?? "-"
                    )
                    
                    


                    tempMks.append(item)
                }
                
                tempMks.sort { $0.id > $1.id }

                self.mks = tempMks
            }
    }
    
    

}
#Preview {
    HomeView()
}
