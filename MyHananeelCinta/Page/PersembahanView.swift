import SwiftUI

struct PersembahanView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {

                    //ayat
                    Text("Berilah kepada Tuhan kemuliaan nama-Nya, bawalah persembahan dan masuklah menghadap Dia! Sujudlah menyembah kepada Tuhan dengan berhiaskan kekudusan. \n \n Gemetarlah di hadapan-Nya hai segenap bumi; sungguh tegak dunia, tidak bergoyang. \n \n Biarlah langit bersukacita dan bumi bersorak-sorai, biarlah orang berkata di antara bangsa-bangsa: “Tuhan itu Raja!.”")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(
                            Color(red: 242/255, green: 219/255, blue: 204/255)
                        )
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    //pasal
                    HStack {
                        Spacer()
                        Text("1 Tawarikh 16:29-31")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Color.orange
                            )
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                    
                    //card persembahan
                    VStack(spacing: 16) {

//                        no rek
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Nomor Rekening BCA")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("A/N JKI HANANEEL")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))


                                Text("003-313-3313")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Button {
                                UIPasteboard.general.string = "0033133313"
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 18))
                                    .foregroundColor(.orange)
                            }
                        }

                        

                    }
                    .padding(20)
                    .background(
                        Color(red: 66/255, green: 66/255, blue: 66/255)
                    )
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 32)
                }
            }
            .background(
                Color(red: 51/255, green: 51/255, blue: 51/255)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Persembahan")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.orange)
                }
            }



        }
        .accentColor(.white)

    }
}


#Preview {
   PersembahanView()
}
