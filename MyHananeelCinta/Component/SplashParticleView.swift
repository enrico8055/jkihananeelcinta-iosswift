import SwiftUI

struct SplashParticleView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(Color.orange.opacity(0.7))
                    .frame(width: CGFloat.random(in: 4...7))
                    .position(
                        x: 75 + CGFloat.random(in: -50...50),
                        y: 75 + CGFloat.random(in: -50...50)
                    )
                    .scaleEffect(animate ? 1 : 0.1)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.0)
                        .delay(Double(i) * 0.03),
                        value: animate
                    )
            }
        }
        .frame(width: 350, height: 350)
        .onAppear {
            animate = true
        }
    }
}
