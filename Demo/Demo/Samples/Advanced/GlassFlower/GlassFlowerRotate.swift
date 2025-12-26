//
//  GlassFlowerRotate.swift
//  Demo
//
//  Created by Ming on 20/4/2025.
//
//  A decorative flower-like component that demonstrates the glass effect
//  with animated petals arranged in a circular pattern.

import SwiftUI
import SwiftGlass

struct GlassFlowerRotate: View {
    // Rainbow color palette for the petals, each petal will use one color from this array
    // Colors are ordered to create a pleasing visual transition when arranged in a circle
    let colors: [Color] = [
        .orange,
        .yellow,
        Color(red: 0.7, green: 1.0, blue: 0.3), // lime green
        .green,
        .blue,
        .purple,
        .red,
        Color(red: 1.0, green: 0.5, blue: 0.5) // coral/light-red
    ]
    
    // Controls the animation state between expanded and contracted form
    @State private var isPulsing = false
    // Controls whether petals are rotated toward center
    @State private var rotateToCenter = false
    
    var body: some View {
        ZStack {
            // Flower petals: Eight capsules arranged in a circle pattern
            // Each petal is a gradient-filled capsule with glass effect applied
            ForEach(0..<8, id: \.self) { index in
                petalView(for: index)
            }
            
            // Button to toggle rotation to center
            rotationButton
        }
        .frame(width: 300, height: 300)
        // Start the pulsing animation when view appears
        .onAppear {
            isPulsing.toggle()
        }
    }
    
    @ViewBuilder
    private func petalView(for index: Int) -> some View {
        let color = colors[index % colors.count]
        let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: color, location: 0),
                .init(color: color.opacity(0.5), location: 1)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
        let baseRotation = Double(index) * 45
        let centerRotation = rotateToCenter ? 720.0 : 0.0
        let pulseAnimation = Animation.easeInOut(duration: 2.0)
            .delay(Double(index) * 0.1)
            .repeatForever(autoreverses: true)
        let rotateAnimation = Animation.easeInOut(duration: 3.5)
            .delay(Double(index) * 0.15)
        
        Capsule()
            .fill(gradient)
            .glass(color: color, colorOpacity: 1, shadowColor: .white)
            .frame(width: 55, height: 100)
            .offset(x: 0, y: 0)
            .rotationEffect(.degrees(baseRotation), anchor: .bottom)
            .rotationEffect(.degrees(centerRotation), anchor: .bottom)
            .offset(y: -50)
            .scaleEffect(isPulsing ? 0.97 : 1.05)
            .animation(pulseAnimation, value: isPulsing)
            .animation(rotateAnimation, value: rotateToCenter)
    }
    
    private var rotationButton: some View {
        Button(action: {
            withAnimation {
                rotateToCenter.toggle()
            }
        }) {
            Text(rotateToCenter ? "Reset Rotation" : "Rotate to Center")
                .foregroundColor(.white)
                .padding(15)
        }
        .cornerRadius(8)
        .glass(color: .blue, shadowColor: .blue)
        .offset(y: 240)
    }
}

// MARK: - Previews

#Preview("Dark") {
    GlassFlowerRotate()
        .preferredColorScheme(.dark)
}
