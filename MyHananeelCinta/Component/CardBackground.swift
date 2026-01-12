
import SwiftUI

struct CardBackground: View {
    var body: some View {
        Color(red: 66/255, green: 66/255, blue: 66/255)
            .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 3)
    }
}

#Preview {
}
