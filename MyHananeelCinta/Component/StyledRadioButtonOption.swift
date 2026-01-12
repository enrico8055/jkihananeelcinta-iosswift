import SwiftUI

struct StyledRadioButtonOption: View {
    var title: String                  // Label untuk radio button
    @Binding var selectedOption: String // Binding ke pilihan terpilih
    var isDisabled: Bool = false       // Kalau mau disable

    var body: some View {
        Button(action: {
            if !isDisabled {
                selectedOption = title
            }
        }) {
            HStack {
                // Circle indicator
                ZStack {
                    Circle()
                        .stroke(isDisabled ? Color.gray : Color.white, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if selectedOption == title {
                        Circle()
                            .fill(isDisabled ? Color.gray : Color.white)
                            .frame(width: 12, height: 12)
                    }
                }

                // Label
                Text(title)
                    .foregroundColor(isDisabled ? Color.gray : Color.white)
                    .font(.system(size: 14, weight: .medium))

                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

