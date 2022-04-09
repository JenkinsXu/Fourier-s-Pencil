//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-08.
//

import SwiftUI
import Algorithms

struct AnimatedView: View {
    @Binding var epicycles: [AnimationGenerator.Epicycle]
    @Binding var keyframes: [[CGPoint]]
    @State var currentFrame = 0
    let animationTimer = Timer.publish(every: 0.05, on: .current, in: .default).autoconnect()
    
    var body: some View {
        Canvas { context, size in
            context.withCGContext { cgContext in
                let centerLocations = keyframes[currentFrame][1...]
                
                // Circles
                cgContext.setStrokeColor(UIColor.systemGray4.cgColor)
                cgContext.setLineWidth(0.4)
                
                for pointsPair in centerLocations.windows(ofCount: 2) {
                    let centerPoint = pointsPair.first!
                    let nextPoint = pointsPair.last!
                    let radius = centerPoint.distanceFrom(nextPoint)
                    
                    let origin = CGPoint(x: centerPoint.x - radius, y: centerPoint.y - radius)
                    let edgeLength = 2 * radius
                    let rectangle = CGRect(origin: origin,
                                           size: CGSize(width: edgeLength, height: edgeLength))
                    let path = CGPath(ellipseIn: rectangle, transform: nil)
                    
                    cgContext.addPath(path)
                    cgContext.drawPath(using: .stroke)
                }
                
                // Lines
                cgContext.setStrokeColor(UIColor.systemGray.cgColor)
                cgContext.setLineWidth(1)
                
                for pointsPair in centerLocations.windows(ofCount: 2) {
                    cgContext.move(to: pointsPair.first!)
                    cgContext.addLine(to: pointsPair.last!)
                }
                
                cgContext.drawPath(using: .stroke)
                
                // Path
                if let resultLocations = epicycles.last?.timedLocations {
                    cgContext.move(to: resultLocations.first!)
                    for pointsPair in resultLocations[0...currentFrame].windows(ofCount: 2) {
                        cgContext.move(to: pointsPair.first!)
                        cgContext.addLine(to: pointsPair.last!)
                    }
                    cgContext.setStrokeColor(UIColor.systemYellow.cgColor)
                    cgContext.drawPath(using: .stroke)
                }
            }
        }
        .onReceive(animationTimer) { _ in
            if currentFrame < AnimationGenerator.numberOfFrames - 1 {
                currentFrame += 1
            }
        }
    }
}
