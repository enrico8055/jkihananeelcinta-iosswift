import SwiftUI

struct ListMezbahKeluargaView: View {
    let mks: [MK]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(mks.indices, id: \.self) { index in
                        let item = mks[index]

                        HStack(alignment: .top, spacing: 12) {

                            VStack {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 12, height: 12)

                                if index != mks.count - 1 {
                                    Rectangle()
                                        .fill(Color.orange.opacity(0.6))
                                        .frame(width: 2, height: 130)
                                }
                            }
                            .frame(width: 12)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.day)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.orange)

                                Text(item.time)
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.7))

                                if !item.desc.isEmpty {
                                    Text(item.desc)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text(item.location)
                                }
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))

                                HStack(spacing: 6) {
                                    Image(systemName: "person.fill")
                                    Text("PIC: \(item.pic)")
                                }
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))

                                if let url = whatsappURL(from: item.contact) {
                                    Link(destination: url) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "phone.fill")
                                            Text(item.contact)
                                        }
                                        .font(.system(size: 13))
                                        .foregroundColor(.green)
                                    }
                                }

                            }
                            .padding(.bottom, 24)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
            .background(
                Color(red: 51/255, green: 51/255, blue: 51/255)
                    .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mezbah Keluarga")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .accentColor(.orange)
    }
    
    func whatsappURL(from phone: String) -> URL? {
        let cleaned = phone
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        return URL(string: "https://wa.me/\(cleaned)")
    }

}
