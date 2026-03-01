//
//  GlassBackgroundModifier.swift
//  SwiftGlass
//
//  Created by Ming on 21/4/2025.
//

import SwiftUI
import UIKit

/// Type-erased shape wrapper
private struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

@available(iOS 15.0, macOS 14.0, watchOS 10.0, tvOS 15.0, visionOS 1.0, *)
public struct GlassBackgroundModifier: ViewModifier {
    /// Controls when the glass effect should be displayed
    public enum GlassBackgroundDisplayMode {
        case always    // Always show the effect
        case automatic // System determines visibility based on context
    }
    
    /// Determines the gradient direction used in the glass effect's border
    public enum GradientStyle {
        case normal    // Light at top-left and bottom-right
        case reverted  // Light at top-right and bottom-left
    }
    
    
    public enum GlassStyle {
        case regular
        case clear
    }
    
    /// Determines the shape of the glass effect
    public enum GlassShape {
        case roundedRectangle(radius: CGFloat)  // Rounded rectangle with custom corner radius
        case circle                             // Perfect circle
        case capsule                           // Capsule shape (pill-shaped)
    }
    
    // Configuration properties for the glass effect
    let displayMode: GlassBackgroundDisplayMode
    let radius: CGFloat
    let shape: GlassShape
    let color: Color
    let colorOpacity: Double
    let material: Material
    let gradientOpacity: Double
    let gradientStyle: GradientStyle
    let strokeWidth: CGFloat
    let shadowColor: Color
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    let shadowX: CGFloat
    let shadowY: CGFloat
    let isInToolbar: Bool
    let style: GlassStyle
    
    /// Creates a new glass effect modifier with the specified appearance settings
    public init(
        displayMode: GlassBackgroundDisplayMode,
        radius: CGFloat,
        shape: GlassShape,
        color: Color,
        colorOpacity: Double,
        material: Material,
        gradientOpacity: Double,
        gradientStyle: GradientStyle,
        strokeWidth: CGFloat,
        shadowColor: Color,
        shadowOpacity: Double,
        shadowRadius: CGFloat?,
        shadowX: CGFloat,
        shadowY: CGFloat,
        isInToolbar: Bool,
        style: GlassStyle
    ) {
        self.displayMode = displayMode
        self.radius = radius
        self.shape = shape
        self.color = color
        self.colorOpacity = colorOpacity
        self.material = material
        self.gradientOpacity = gradientOpacity
        self.gradientStyle = gradientStyle
        self.strokeWidth = strokeWidth
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius ?? radius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.isInToolbar = isInToolbar
        self.style = style
    }
    
    /// Applies the glass effect to the content view
    /// Implementation uses three primary techniques:
    /// 1. Material background for the frosted effect
    /// 2. Gradient stroke for edge highlighting
    /// 3. Shadow for depth perception
    public func body(content: Content) -> some View {
        // Check isInToolbar and iOS version first
        if isInToolbar {
            // Check if we're on iOS 26+
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *) {
                // On iOS 26+, return content with tint only (no glass effect, no border)
                return AnyView(content.tint(color))
            }
            // On iOS 18 and below, still apply glass effect when in toolbar
            return AnyView(fallbackGlassEffect(content: content))
        }
        
        // Not in toolbar - apply glass effect based on iOS version
        #if swift(>=6.0) && canImport(SwiftUI, _version: 6.0)
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *) {
            // On iOS 26+, use native glassEffect API for rounded rectangles
            // For circle and capsule, use fallback to ensure proper shape support
            if case .roundedRectangle(let radius) = shape {
                return AnyView(
                    content
                        #if !os(visionOS)
                        .glassEffect(.regular.tint(color.opacity(colorOpacity)).interactive(), in: .rect(cornerRadius: radius))
                        #else
                        .background(color.opacity(colorOpacity))
                        .background(material)
                        .clipShape(shapeForClipping())
                        .overlay(
                            shapeForOverlay()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors()),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: strokeWidth
                                )
                        )
                        #endif
                        .shadow(color: shadowColor.opacity(shadowOpacity), radius: shadowRadius, x: shadowX, y: shadowY)
                )
            } else {
                // For circle and capsule, use fallback implementation
                return AnyView(fallbackGlassEffect(content: content))
            }
        } else {
            return AnyView(fallbackGlassEffect(content: content))
        }
        #else
        return AnyView(fallbackGlassEffect(content: content))
        #endif
    }
    
    /// Fallback glass effect implementation for older Xcode versions
    private func fallbackGlassEffect(content: Content) -> AnyView {
        return AnyView(
            content
//                .background(color.opacity(colorOpacity))
                .if(style == .clear, then: {
                    $0.background(UltraLightGlass(alpha: 0.35))
                }, else: {
                    $0.background(material)
                }) // Use the specified material for the frosted glass base
                .clipShape(shapeForClipping()) // Clip to the specified shape
                .overlay(
                    // Adds subtle gradient border for dimensional effect
                    shapeForOverlay()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors()),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: strokeWidth
                        )
                )
                // Adds shadow for depth and elevation
                .shadow(color: shadowColor.opacity(shadowOpacity), radius: shadowRadius, x: shadowX, y: shadowY)
        )
    }
    
    /// Returns the appropriate shape for clipping
    private func shapeForClipping() -> AnyShape {
        switch shape {
        case .roundedRectangle(let radius):
            return AnyShape(RoundedRectangle(cornerRadius: radius))
        case .circle:
            return AnyShape(Circle())
        case .capsule:
            return AnyShape(Capsule())
        }
    }
    
    /// Returns the appropriate shape for overlay stroke
    private func shapeForOverlay() -> AnyShape {
        switch shape {
        case .roundedRectangle(let radius):
            return AnyShape(RoundedRectangle(cornerRadius: radius))
        case .circle:
            return AnyShape(Circle())
        case .capsule:
            return AnyShape(Capsule())
        }
    }
    
    /// Generates the gradient colors based on the selected style
    /// Creates the illusion of light reflection on glass edges
    private func gradientColors() -> [Color] {
        switch gradientStyle {
        case .normal:
            return [
                color.opacity(gradientOpacity),
                color.opacity(gradientOpacity).opacity(0.2),
                color.opacity(gradientOpacity).opacity(0.2),
                color.opacity(gradientOpacity)
            ]
        case .reverted:
            return [
                color.opacity(gradientOpacity).opacity(0.2),
                color.opacity(gradientOpacity),
                color.opacity(gradientOpacity),
                color.opacity(gradientOpacity).opacity(0.2),
            ]
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        @ViewBuilder then: (Self) -> TrueContent,
        @ViewBuilder `else`: (Self) -> FalseContent
    ) -> some View {
        Group {
            if condition {
                then(self)
            } else {
                `else`(self)
            }
        }
    }
}

fileprivate struct UltraLightGlass: View {
    var alpha: Double = 0.4

    var body: some View {
        #if os(iOS) || os(tvOS)
        UltraLightBlur(alpha: alpha)
        #else
        Color.white.opacity(alpha * 0.3)
        #endif
    }
}

#if os(iOS) || os(tvOS)

import SwiftUI
import UIKit

@available(iOS 15.0, tvOS 15.0, *)
fileprivate struct UltraLightBlur: UIViewRepresentable {

    var blurStyle: UIBlurEffect.Style = .systemUltraThinMaterial
    var alpha: CGFloat = 0.4

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: blurStyle)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = alpha
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.alpha = alpha
    }
}

#endif
