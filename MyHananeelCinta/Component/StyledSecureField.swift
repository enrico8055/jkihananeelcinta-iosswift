
import SwiftUI

struct StyledSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.5)))
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color(red: 66/255, green: 66/255, blue: 66/255))
            .foregroundColor(.white)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.white)
                    .padding(.top, 44)
            )
    }
}

#Preview {
}
