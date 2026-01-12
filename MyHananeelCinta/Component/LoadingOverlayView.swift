import SwiftUI

struct LoadingOverlayView: View {
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    .scaleEffect(1.3)
            }
            .padding(24)
            .background(Color.black.opacity(0.8))
            .cornerRadius(14)
        }
        .transition(.opacity)
        .zIndex(99)
    }
}
