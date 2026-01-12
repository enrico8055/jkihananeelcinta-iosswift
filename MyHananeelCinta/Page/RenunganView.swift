import SwiftUI

struct RenunganView: View {
    let renungan:Renungan;
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // HEADER
                    VStack(alignment: .leading, spacing: 4) {
                        Text(renungan.title)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(
                                Color(red: 242/255, green: 219/255, blue: 204/255)
                            )
                    }
                    .padding(.top, 16)

                    Divider()
                        .background(Color.white.opacity(0.15))

                    // ISI
                    Text(renungan.messages)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                    
                    HStack {
                        Spacer()

                        Text("Written By "+renungan.writer)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.orange)
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
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
        .accentColor(.white)

    }
}


#Preview {
}
