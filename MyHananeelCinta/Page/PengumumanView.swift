import SwiftUI

struct PengumumanView: View {
    let announcement:Announcement;
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    ZStack(alignment: .bottomLeading) {

                        //gambar pengumuman
                        AsyncImage(
                            url: URL(string: announcement.imageUrl)
                        ) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    ProgressView()
                                }

                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()

                            case .failure:
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.white.opacity(0.6))
                                }

                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(height: 240)
                        .clipped()

                        
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.0),
                                Color.black.opacity(0.7)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        //judul
                        VStack(alignment: .leading, spacing: 6) {
                            Text(announcement.title)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(
                                    Color(red: 242/255, green: 219/255, blue: 204/255)
                                )
                        }
                        .padding()
                    }


                    // isi
                    Text(announcement.desc)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    
                    
                    //link
                    if(announcement.infoUrl != ""){
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Link")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            HStack(spacing: 12) {
                                if let url = URL(string: announcement.infoUrl),
                                   UIApplication.shared.canOpenURL(url) {
                                    
                                    Button(action: {
                                        UIApplication.shared.open(url)
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "link")
                                                .font(.system(size: 14))
                                                .foregroundColor(.blue)
                                            
                                            Text(announcement.infoUrl)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.blue)
                                                .underline()
                                                .lineLimit(1)
                                        }
                                    }
                                } else {
                                    HStack(spacing: 8) {
                                        Image(systemName: "link")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Text(announcement.infoUrl)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(14)
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
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    
                    //contact person
                    if announcement.contactPersonName != "" && announcement.contactPerson != "" {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Contact Person")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            Button {
                                openWhatsApp(number: announcement.contactPerson)
                            } label: {
                                HStack(spacing: 12) {
                                    
                                    // icon
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.orange)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        
                                        // nama
                                        Text(announcement.contactPersonName)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        // no tel
                                        HStack(spacing: 6) {
                                            Image(systemName: "phone.fill")
                                                .font(.system(size: 12))
                                            Text(announcement.contactPerson)
                                                .font(.system(size: 14))
                                        }
                                        .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.green)
                                }
                                .padding(14)
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
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    
                    

                }
            }
            .background(
                Color(red: 51/255, green: 51/255, blue: 51/255)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Detail Pengumuman")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }


        }
        .accentColor(.white)

    }
    
    func openWhatsApp(number: String) {
        let cleanedNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var whatsappNumber = cleanedNumber
        
        if whatsappNumber.hasPrefix("0") {
            whatsappNumber = "+62" + whatsappNumber.dropFirst()
        }
        else if !whatsappNumber.hasPrefix("+") {
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
}


#Preview {
}
