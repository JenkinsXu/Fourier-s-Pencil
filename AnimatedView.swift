//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-08.
//

import SwiftUI
import Algorithms

struct AnimatedView: View {
    @Binding var epicycles: [AnimationGenerator.KeyFrame]
    
    var body: some View {
        Canvas { context, size in
            context.withCGContext { cgContext in
                let locations = epicycles.last!.timedLocations
                cgContext.setStrokeColor(UIColor.orange.cgColor)
                cgContext.setLineWidth(2)
                
                for pointsPair in locations.windows(ofCount: 2) {
//                    print(pointsPair)
                    cgContext.move(to: pointsPair.first!)
                    cgContext.addLine(to: pointsPair.last!)
                    cgContext.drawPath(using: .stroke)
                }
                
//                cgContext.drawPath(using: .stroke)
            }
        }
    }
}
