import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct ListDoaView: View {
    var userName: String
    @State private var doas: [Doa] = []
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    if doas.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.5))

                            Text("Belum ada permohonan doa")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(doas) { item in
                                NavigationLink(
                                    destination: EmptyView()
                                ) {
                                    VStack(alignment: .leading, spacing: 10) {

                                        Text("\(item.date)")
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.6))

                                        Text(item.prayType)
                                            .font(.system(size: 20))
                                            .foregroundColor(
                                                Color(red: 242/255, green: 219/255, blue: 204/255)
                                            )

                                        // isi
                                        Text(item.prayDesc)
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                            .lineLimit(10)
                                            .multilineTextAlignment(.leading)
                                        
                                        
                                        if item.status == "DONE" {
                                            HStack {
                                                Spacer()
                                                Text("Hasil Doa")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(
                                                        Color(red: 242/255, green: 219/255, blue: 204/255)
                                                    )
                                                    .lineLimit(10)
                                                    .multilineTextAlignment(.trailing)
                                            }
                                            HStack {
                                                Spacer()
                                                Text(item.prayResult)
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.white)
                                                    .lineLimit(10)
                                                    .multilineTextAlignment(.trailing)
                                            }
                                        }
                                        
                                        

                                        //status
                                        var statusLabel: String {
                                            switch item.status {
                                            case "DONE":
                                                return "SELESAI"
                                            case "IN_PROGRESS":
                                                return "DALAM PROSES"
                                            case "OPEN":
                                                return "ANTRIAN"
                                            default:
                                                return item.status
                                            }
                                        }
                                        var statusColor: Color {
                                            switch item.status {
                                            case "DONE": return .green
                                            case "IN_PROGRESS": return .orange
                                            case "OPEN": return .blue
                                            default: return .white.opacity(0.7)
                                            }
                                        }
                                        HStack {
                                            Spacer()
                                            Text(statusLabel)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(statusColor)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(statusColor.opacity(0.1))
                                                .cornerRadius(5)
                                        }
                                    }
                                    .padding(16)
                                    .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                                    .cornerRadius(14)
                                    .shadow(
                                        color: Color.black.opacity(0.4),
                                        radius: 6,
                                        x: 0,
                                        y: 3
                                    )
                                }.allowsHitTesting(false)
                            }
                        }
                        .padding(16)
                    }
                }
                .background(
                    Color(red: 51/255, green: 51/255, blue: 51/255)
                )

                
                // Floating Button add
                NavigationLink(destination: AddDoaView(userName: userName)) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.orange)
                        .clipShape(Circle())
                        .shadow(
                            color: Color.black.opacity(0.3),
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Daftar Doa")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .accentColor(.orange)
        .onAppear(){
            fetchDoas()
        }
    }
    
    func fetchDoas() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("prayerRequest")
            .queryOrdered(byChild: "requesterId")
            .queryEqual(toValue: uid)
            .observeSingleEvent(of: .value) { snapshot in

                var tempDoas: [Doa] = []

                for child in snapshot.children {
                    guard
                        let snap = child as? DataSnapshot,
                        let data = snap.value as? [String: Any]
                    else { continue }
                    
                    let dateString: String
                    
                    if let timestamp = Double(snap.key) {
                        let timestampInSeconds: Double
                        
                        if timestamp > 1_000_000_000_000 {
                            timestampInSeconds = timestamp / 1000
                        } else {
                            timestampInSeconds = timestamp
                        }
                        
                        let dateObj = Date(timeIntervalSince1970: timestampInSeconds)
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        dateString = formatter.string(from: dateObj)
                    } else {
                        dateString = snap.key
                    }

                    let item = Doa(
                        id: snap.key,
                        prayType: data["prayType"] as? String ?? "-",
                        requesterName: data["requesterName"] as? String ?? "-",
                        status: data["status"] as? String ?? "-",
                        handlerName: data["handlerName"] as? String ?? "-",
                        prayDesc: data["prayDesc"] as? String ?? "-",
                        requesterId: data["requesterId"] as? String ?? "-",
                        date: dateString,
                        prayResult: data["prayResult"] as? String ?? "-"
                    )
                    
                    tempDoas.append(item)
                }
                
                tempDoas.sort { $0.id > $1.id }

                self.doas = tempDoas
            }
    }
}


#Preview {
}
