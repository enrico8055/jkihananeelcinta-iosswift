import SwiftUI

struct ListRenunganView: View {
    var renungans: [Renungan]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(renungans) { item in
                        NavigationLink(
                            destination: RenunganView(renungan: item)
                        ) {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // TANGGAL
                                    Text(item.date)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    // JUDUL
                                    Text(item.title)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(
                                            Color(red: 242/255, green: 219/255, blue: 204/255)
                                        )
                                    
                                    // ISI POTONGAN
                                    Text(item.messages)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .lineLimit(10)
                                        .multilineTextAlignment(.leading)
                                    
                                    // PENULIS (KANAN BAWAH)
                                    HStack {
                                        Spacer()
                                        Text("Written by: "+item.writer)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding(16)
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
                }
                .padding(16)
            }
            .background(
                Color(red: 51/255, green: 51/255, blue: 51/255)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Renungan")
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
