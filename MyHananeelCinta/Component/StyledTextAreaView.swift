import SwiftUI

struct StyledTextAreaView: View {
    var placeholder: String
    @Binding var text: String
    var isDisabled: Bool = false
    var height: CGFloat = 120
    var backgroundColor: Color = Color(red: 66/255, green: 66/255, blue: 66/255)
    var foregroundColor: Color = .white

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(placeholder)
                .foregroundColor(foregroundColor)
                .font(.system(size: 14, weight: .medium))
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(foregroundColor.opacity(0.5))
                        .padding(EdgeInsets(top: 12, leading: 8, bottom: 0, trailing: 0))
                        .font(.system(size: 14))
                }

                TextEditor(text: $text)
                    .foregroundColor(foregroundColor)
                    .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
                    .frame(height: height)
                    .disabled(isDisabled)
                    .background(backgroundColor)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(foregroundColor, lineWidth: 1)
                    )
                    .scrollContentBackground(.hidden)
            }
        }
        .padding(.vertical, 4)
    }
}



