import SwiftUI
internal import Combine

struct ConfettiView: View {
    @State private var confettis: [Confetti] = []

    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(confettis) { confetti in
                    Rectangle()
                        .fill(confetti.color)
                        .frame(width: confetti.size, height: confetti.size * 1.5)
                        .rotationEffect(confetti.rotation)
                        .position(confetti.position)
                }
            }
            .onReceive(timer) { _ in
                addConfetti(width: geo.size.width)
                moveConfetti(height: geo.size.height)
            }
        }
        .ignoresSafeArea()
    }

    private func addConfetti(width: CGFloat) {
        let new = Confetti(
            position: CGPoint(x: .random(in: 0...width), y: -10),
            size: .random(in: 6...10),
            rotation: .degrees(.random(in: 0...360)),
            color: [.red, .orange, .yellow, .green, .blue, .purple].randomElement()!
        )
        confettis.append(new)

        if confettis.count > 80 {
            confettis.removeFirst()
        }
    }

    private func moveConfetti(height: CGFloat) {
        for i in confettis.indices {
            confettis[i].position.y += CGFloat.random(in: 8...14)
            confettis[i].rotation += .degrees(10)

            if confettis[i].position.y > height {
                confettis.remove(at: i)
                break
            }
        }
    }
}

struct Confetti: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var rotation: Angle
    var color: Color
}
