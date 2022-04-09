//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-08.
//

import SwiftUI
import Algorithms

struct AnimatedView: View {
    @Binding var keyframes: [AnimationGenerator.Keyframe]
    
    var body: some View {
        Canvas { context, size in
            context.withCGContext { cgContext in
                let locations = keyframes.last!.timedLocations
                cgContext.setStrokeColor(UIColor.orange.cgColor)
                cgContext.setLineWidth(2)
                
                for pointsPair in locations.windows(ofCount: 2) {
                    cgContext.move(to: pointsPair.first!)
                    cgContext.addLine(to: pointsPair.last!)
                }
                
                cgContext.drawPath(using: .stroke)
            }
        }
    }
}
