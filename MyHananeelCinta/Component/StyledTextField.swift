
import SwiftUI

struct StyledTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false
    var isOnlyField: Bool = false
    
    var body: some View {
        if(!isOnlyField){
            Text(placeholder)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .medium))
        }
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.5)))
            .keyboardType(keyboardType)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color(red: 66/255, green: 66/255, blue: 66/255))
            .foregroundColor(.white)
            .disabled(isDisabled)
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
