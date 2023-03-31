//
//  Dust.swift
//  Box
//
//  Created by Jeremy Marchand on 23/03/2023.
//

import SwiftUI

/// Floor Dust animation based on custom particles system for box falling down.
///
/// Not the most optimised particle system, but it does the job for the demo.
@available(macOS 13.0, iOS 16, *)
struct Dust: View {
    @State private var particles: [Particle] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .blur(radius: 8)
                        .opacity(particle.opacity)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                }
            }
            .task {
                createParticles(in: geometry)
               await animationLoop()
            }
        }
        .drawingGroup(opaque: false)
    }

    func createParticles(in geometry: GeometryProxy) {
        withAnimation(.easeIn(duration: 0.3)) {
            for _ in 0...50 {
                let radius: CGFloat = geometry.size.width/2 // set the radius of the demi-circle
                let centerPoint = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2) // set the center point of the demi-circle
                let angle = CGFloat.random(in: 0...(CGFloat.pi)) // get a random angle between 0 and pi

                let x = centerPoint.x + radius * cos(angle) + CGFloat.random(in: -10...10)
                let y = centerPoint.y + radius * sin(angle) + CGFloat.random(in: -20...20)

                let dx =  CGFloat.random(in: 0...40) * cos(angle)
                let dy =  CGFloat.random(in: -15...5) * sin(angle)

                particles.append(Particle(size: CGFloat.random(in: 20...80),
                                          position: CGPoint(x: x, y: y),
                                          velocity: CGVector(dx: dx, dy: dy),
                                          opacity: CGFloat.random(in: 0.2...0.7)))
            }
        }
    }

    func animationLoop() async {
        do {
            while !particles.isEmpty {
                try await Task.sleep(until: .now + .milliseconds(300), tolerance: Duration.milliseconds(100), clock: .continuous)

                let newParticles = await Task.detached {
                    var particles = self.particles
                    particles.removeAll { particle in
                        particle.life <= 0
                    }
                    for i in particles.indices {
                        particles[i].position.x += particles[i].velocity.dx
                        particles[i].position.y += particles[i].velocity.dy
                        particles[i].life -= 1
                        particles[i].opacity *= 0.83
                    }

                    return particles
                }.value

                withAnimation(.linear(duration: 0.3)) {
                    self.particles = newParticles
                }
            }
        } catch {

        }
    }
}

private struct Particle: Identifiable {
    let id = UUID()
    var size: CGFloat
    var position: CGPoint
    var velocity: CGVector
    var opacity: Double

    var life: Int = 60
}

@available(macOS 13.0, iOS 16, *)
struct Dust_Previews: PreviewProvider {
    static var previews: some View {
        Dust()
            .foregroundColor(.white)
            .frame(width: 200)
            .background(.black)
    }
}
