import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct HomeAdminView: View {
    @State private var totalJemaat = 0
    @State private var totalPastor = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {

                        // AYAT
                        VStack(spacing: 8) {
                            Text("Ibrani 10:25")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.orange)

                            Text("Janganlah kita menjauhkan diri dari pertemuan-pertemuan ibadah kita, seperti dibiasakan olehh beberapa orang, tetap marilah kita saling menasihati, dan semakin giat melakukannya menjelang hari Tuhan yang dekat.")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // BOX TOTAL
                        HStack(spacing: 16) {

                            NavigationLink(destination: ListJemaatView()) { // Ganti AllUsersView() dengan halaman tujuan
                                VStack(spacing: 8) {
                                    Text("\(totalJemaat)")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.orange)

                                    Text("Total Jemaat")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                                .cornerRadius(14)
                            }
                            .buttonStyle(PlainButtonStyle()) // Supaya tidak ada efek highlight default

                            VStack(spacing: 8) {
                                Text("\(totalPastor)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.orange)

                                Text("Total Pastor / Admin")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                            .cornerRadius(14)
                        }
                        .padding(.horizontal, 16)

                        // MENU 1
                        HStack(spacing: 14) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.orange)

                            Text("Daftar Renungan (Coming Soon)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding()
                        .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 3)
                        .padding(.horizontal, 16)

                        // MENU 2
                        HStack(spacing: 14) {
                            Image(systemName: "megaphone.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.orange)

                            Text("Daftar Pengumuman (Coming Soon)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding()
                        .background(Color(red: 66/255, green: 66/255, blue: 66/255))
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 3)
                        .padding(.horizontal, 16)

                        // MENU 3
                        NavigationLink(destination: ListUlangTahunView()) {
                            HStack(spacing: 14) {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.orange)

                                Text("Ulang Tahun")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.5))
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
                        }
                        .padding(.horizontal, 16)

                    }
                }
                .background(Color(red: 51/255, green: 51/255, blue: 51/255))

                
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Admin")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .accentColor(.orange)
        .onAppear(){
            fetchUserCounts()
        }
    }
    
    
    func fetchUserCounts() {
        let ref = Database.database().reference()

        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            var jemaat = 0
            var pastor = 0

            for child in snapshot.children {
                guard
                    let snap = child as? DataSnapshot,
                    let data = snap.value as? [String: Any]
                else { continue }

                let role = data["role"] as? String ?? ""

                if role == "Jemaat" {
                    jemaat += 1
                } else if role == "SuperUser" {
                    pastor += 1
                }
            }

            self.totalJemaat = jemaat
            self.totalPastor = pastor
        }
    }
    
    
}


#Preview {
}
