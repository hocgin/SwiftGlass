//
//  Circle.swift
//  Demo
//
//  Created by Ming on 22/4/2025.
//

import SwiftUI
import SwiftGlass

struct CircleGlass: View {
    var body: some View {
        ZStack {
            #if !os(visionOS) && !os(watchOS) && !os(macOS)
            background
            #endif
            
            VStack(spacing: 30) {
                // Circle shape example
                VStack(spacing: 15) {
                    Image(systemName: "circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    Text("Circle Glass")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(width: 150, height: 150)
                .glass(shape: .circle, color: .blue, shadowColor: .blue)
                
                // Multiple circles with different colors
                HStack(spacing: 20) {
                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 100, height: 100)
                    .glass(shape: .circle, color: .pink, shadowColor: .pink)
                    
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 100, height: 100)
                    .glass(shape: .circle, color: .yellow, shadowColor: .yellow)
                    
                    VStack {
                        Image(systemName: "leaf.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 100, height: 100)
                    .glass(shape: .circle, color: .green, shadowColor: .green)
                }
            }
            #if !os(watchOS)
            .padding(25)
            #else
            .padding(15)
            #endif
        }
    }
    
    // Add a background for better looking
    var background: some View {
        Group {
            Color.black
                .ignoresSafeArea()
            
            AsyncImage(url: URL(string: "https://shareby.vercel.app/3vj7gk")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }.opacity(0.3)
            .ignoresSafeArea()
        }
    }
}

#Preview("Light") {
    CircleGlass()
}

#Preview("Dark") {
    CircleGlass()
        .preferredColorScheme(.dark)
}

