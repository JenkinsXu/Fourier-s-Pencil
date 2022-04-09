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
    let animationTimer = Timer.publish(every: 0.002, on: .current, in: .default).autoconnect()
    
    var body: some View {
        Canvas { context, size in
            context.withCGContext { cgContext in
                let centerLocations = keyframes[currentFrame]
                cgContext.setStrokeColor(UIColor.orange.cgColor)
                cgContext.setLineWidth(2)
                
                for pointsPair in centerLocations.windows(ofCount: 2) {
                    cgContext.move(to: pointsPair.first!)
                    cgContext.addLine(to: pointsPair.last!)
                }
                
                cgContext.drawPath(using: .stroke)
                
                if let resultLocations = epicycles.last?.timedLocations {
                    cgContext.move(to: resultLocations.first!)
                    for pointsPair in resultLocations[0...currentFrame].windows(ofCount: 2) {
                        cgContext.move(to: pointsPair.first!)
                        cgContext.addLine(to: pointsPair.last!)
                    }
                    cgContext.setStrokeColor(UIColor.purple.cgColor)
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
