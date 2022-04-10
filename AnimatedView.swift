//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-08.
//

import SwiftUI
import Algorithms

struct AnimatedView: View {
    @State private var opacity = 1.0
    @Binding var epicycles: [AnimationGenerator.Epicycle]
    @Binding var keyframes: [[CGPoint]]
    @Environment(\.dismiss) var dismiss: DismissAction
    @State private var currentFrame = 0
    @State private var showExplaination = false
    
    let animationTimer = Timer.publish(every: 0.027, on: .current, in: .default).autoconnect()
    @State private var shouldListenToTimer = true
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private var navigationTitleText: String {
        switch horizontalSizeClass {
        case .regular:
            return "Complex Fourier Series"
        case .compact:
            return "Fourier Series"
        default:
            return "Loading"
        }
    }
    
    var body: some View {
        NavigationView {
            Canvas { context, size in
                context.withCGContext { cgContext in
                    let centerLocations = keyframes[currentFrame][1...]
                    
                    // Circles
                    let circleColor1 = UIColor.systemBrown.cgColor
                    let circleColor2 = UIColor.systemCyan.cgColor
                    var currentPairIndex = 0
                    cgContext.setLineWidth(0.3)
                    
                    for pointsPair in centerLocations.windows(ofCount: 2) {
                        let centerPoint = pointsPair.first!
                        let nextPoint = pointsPair.last!
                        let radius = centerPoint.distanceFrom(nextPoint)
                        
                        let origin = CGPoint(x: centerPoint.x - radius, y: centerPoint.y - radius)
                        let edgeLength = 2 * radius
                        let rectangle = CGRect(origin: origin,
                                               size: CGSize(width: edgeLength, height: edgeLength))
                        let path = CGPath(ellipseIn: rectangle, transform: nil)
                        
                        let circleColor = (currentPairIndex % 2 == 0) ? circleColor1 : circleColor2
                        cgContext.setStrokeColor(circleColor)
                        currentPairIndex += 1
                        
                        cgContext.addPath(path)
                        cgContext.drawPath(using: .stroke)
                    }
                    
                    // Lines
                    cgContext.setStrokeColor(UIColor.label.cgColor)
                    
                    for pointsPair in centerLocations.windows(ofCount: 2) {
                        let currentPoint = pointsPair.first!
                        let nextPoint = pointsPair.last!
                        
                        let distance = currentPoint.distanceFrom(nextPoint)
                        let lineWidth = (distance / 40) > 1 ? 1 : (distance / 40)
                        cgContext.setLineWidth(lineWidth)
                        
                        cgContext.move(to: currentPoint)
                        cgContext.addLine(to: nextPoint)
                        cgContext.drawPath(using: .stroke)
                    }
                    
                    // Path
                    cgContext.setStrokeColor(UIColor.systemYellow.cgColor)
                    
                    if let resultLocations = epicycles.last?.timedLocations {
                        cgContext.move(to: resultLocations.first!)
                        var currentPairIndex = 0
                        for pointsPair in resultLocations[0...currentFrame].windows(ofCount: 2) {
                            cgContext.move(to: pointsPair.first!)
                            cgContext.addLine(to: pointsPair.last!)
                            
                            cgContext.setLineWidth(CGFloat(currentPairIndex) / CGFloat(currentFrame) * 2.5)
                            cgContext.drawPath(using: .stroke)
                            currentPairIndex += 1
                        }
                    }
                }
            }
            .accessibilityLabel("Spinning vectors connected together, with the last vector drawing the curve you just drew.")
            .opacity(opacity)
            .navigationTitle(navigationTitleText)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(animationTimer) { _ in
                if currentFrame < AnimationGenerator.numberOfFrames - 1 {
                    currentFrame += 1
                } else {
                    guard shouldListenToTimer else { return }
                    withAnimation(.easeInOut(duration: 0.8)) {
                        opacity = 0.0
                    }
                    shouldListenToTimer = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        currentFrame = 0
                        shouldListenToTimer = true
                        withAnimation(.easeInOut(duration: 0.8)) {
                            opacity = 1.0
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("What is this?") { showExplaination = true }
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showExplaination) {
                ExplainationView()
            }
        }
    }
}
