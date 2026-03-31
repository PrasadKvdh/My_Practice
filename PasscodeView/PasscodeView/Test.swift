//
//  Test.swift
//  DisplayScreen
//
//  Created by mac_admin on 10/16/25.
//
import SwiftUI

struct LiquidGlassText: View {
    let text: String
    let font: Font
    
    var body: some View {
        // Place the text to define size/layout
        Text(text)
            .font(font)
            .foregroundStyle(.clear) // Make the base glyphs transparent
            .overlay {
                // Apply the glass effect to a clear layer
                Color.clear
                    .glassEffect(.clear)
                    // Reveal the effect only where the text is
                    .mask(
                        Text(text).font(font)
                    )
            }
    }
}

struct ContentView1: View {
    var body: some View {
        ZStack {
            // A dynamic background to show the effect
            LinearGradient(
                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            LiquidGlassText(text: "Liquid Text", font: .system(size: 50, weight: .bold))
                .foregroundStyle(.white) // Optional tinting of the glass highlight
                .padding()
        }
    }
}

#Preview {
    ContentView1()
}

