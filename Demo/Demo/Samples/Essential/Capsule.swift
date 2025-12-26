//
//  Capsule.swift
//  Demo
//
//  Created by Ming on 22/4/2025.
//

import SwiftUI
import SwiftGlass

struct CapsuleGlass: View {
    var body: some View {
        ZStack {
            #if !os(visionOS) && !os(watchOS) && !os(macOS)
            background
            #endif
            
            VStack(spacing: 30) {
                // Capsule shape example
                HStack {
                    Image(systemName: "capsule.fill")
                        .font(.title2)
                    Text("Capsule Glass")
                        .font(.headline)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .glass(shape: .capsule, color: .purple, shadowColor: .purple)
                
                // Multiple capsules with different styles
                VStack(spacing: 20) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play Music")
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 12)
                    }
                    .glass(shape: .capsule, color: .blue, shadowColor: .blue)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 12)
                    }
                    .glass(shape: .capsule, color: .orange, shadowColor: .orange)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("Stop")
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 12)
                    }
                    .glass(shape: .capsule, color: .red, shadowColor: .red)
                }
                
                // Horizontal capsule badges
                HStack(spacing: 15) {
                    Text("New")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glass(shape: .capsule, color: .green, shadowColor: .green)
                    
                    Text("Hot")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glass(shape: .capsule, color: .red, shadowColor: .red)
                    
                    Text("Sale")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glass(shape: .capsule, color: .yellow, shadowColor: .yellow)
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
    CapsuleGlass()
}

#Preview("Dark") {
    CapsuleGlass()
        .preferredColorScheme(.dark)
}

