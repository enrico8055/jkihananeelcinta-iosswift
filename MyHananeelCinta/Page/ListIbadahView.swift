import SwiftUI

struct ListIbadahView: View {
    var mks: [MK]

    let ibadahs: [(icon: String, judul: String, isi: String, jadwal: [String])] = [
        (
            "building.columns.fill",
            "Ibadah Raya",
            "Memuji, menyembah Tuhan secara korporat dan menerima santapan rohani yang baik untuk roh, jiwa dan tubuh kita",
            [
                "Ibadah 1 : Minggu, 07.00 - 09.00 WIB",
                "Ibadah 2 : Minggu, 10.00 - 12.00 WIB"
            ]
        ),
        (
            "bird.fill",
            "Holy Spirit Night",
            "Memperdalam hubungan pribadi dengan Roh Kudus, sehingga setiap kita mampu berjalan hari demi hari bersama-Nya",
            [
                "Selasa, 19.00 - 21.00 WIB"
            ]
        ),
        (
            "person.3.fill",
            "Mezbah Keluarga",
            "Memelihara dan memperkuat keluarga kita dalam iman dan pengajaran yang benar tentang Tuhan lewar sharing dan kebersamaan",
            [
            ]
        ),
        (
            "figure.child",
            "Sekolah Minggu ",
            "Mendidik anak-anak untuk mengenal dan mencintai Tuhan dengan benar dari masa kecilnya, sehingga mempunyai dasar yang kuat",
            [
                "Ibadah 1 : Minggu, 07.00 - 09.00 WIB",
                "Ibadah 2 : Minggu, 10.00 - 12.00 WIB"
            ]
        ),
        (
            "figure.2.and.child.holdinghands",
            "Youth",
            "Membangkitkan generasi muda yang cinta dan takut akan Tuhan untuk membawa keluar jiwa-jiwa dari dalam kegelapan dan menjadi anak panah Tuhan di akhir jaman",
            [
                "Jumat, 19.00 - 21.00 WIB",
            ]
        )
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    //header ayat
                    VStack(spacing: 8) {
                        Text("“Janganlah kita menjauhkan diri dari pertemuan-pertemuan ibadah kita, seperti dibiasakan oleh beberapa orang, tetapi marilh kita saling menasihati, dan semakin giat melakukan menjelang hari Tuhan yang mendekat.”")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(
                                Color(red: 242/255, green: 219/255, blue: 204/255)
                            )
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)

                        HStack {
                            Spacer()
                            Text("Ibrani 10:25")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    .background(
                        Color(red: 66/255, green: 66/255, blue: 66/255)
                    )
                    .cornerRadius(14)
                    .shadow(
                        color: Color.black.opacity(0.4),
                        radius: 6,
                        x: 0,
                        y: 3
                    )

                    //list ibadah
                    VStack(spacing: 16) {
                        ForEach(ibadahs.indices, id: \.self) { index in
                            let item = ibadahs[index]

                            HStack(alignment: .top, spacing: 14) {

                                // ICON
                                Image(systemName: item.icon)
                                    .font(.system(size: 26))
                                    .foregroundColor(.orange)
                                    .frame(width: 30)

                                // CONTENT
                                VStack(alignment: .leading, spacing: 10) {

                                    // JUDUL
                                    Text(item.judul)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(
                                            Color(red: 242/255, green: 219/255, blue: 204/255)
                                        )

                                    // ISI
                                    Text(item.isi)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .lineLimit(3)

                                    // JADWAL (BISA BANYAK)
                                    VStack(alignment: .leading, spacing: 6) {
                                        ForEach(item.jadwal, id: \.self) { waktu in
                                            HStack(spacing: 6) {
                                                Image(systemName: "clock")
                                                    .font(.system(size: 13))
                                                Text(waktu)
                                                    .font(.system(size: 13))
                                            }
                                            .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    
                                    if(item.judul == "Mezbah Keluarga"){
                                        NavigationLink(
                                            destination: ListMezbahKeluargaView(mks: mks)
                                        ) {
                                            HStack{
                                                Spacer()
                                                Text("Lihat Daftar")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.orange)
                                                    .lineLimit(3)
                                                
                                            }
                                        }
                                    }

                                }
                                
                                
                                
                                Spacer()
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity) // 👈 BIAR RAPI
                            .background(
                                Color(red: 66/255, green: 66/255, blue: 66/255)
                            )
                            .cornerRadius(14)
                            .shadow(
                                color: Color.black.opacity(0.4),
                                radius: 6,
                                x: 0,
                                y: 3
                            )
                        }
                    }
                }
                .padding(16)
            }
            .background(
                Color(red: 51/255, green: 51/255, blue: 51/255)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Ibadah")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .accentColor(.orange)
    }
}

#Preview {
}
