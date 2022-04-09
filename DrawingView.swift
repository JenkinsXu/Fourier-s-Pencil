//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-07.
//

import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    private let canvasViewDelegate = CanvasViewDelegate()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen)
        canvasView.delegate = canvasViewDelegate
        return canvasView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

class CanvasViewDelegate: NSObject, PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        canvasView.isUserInteractionEnabled = canvasView.drawing.strokes.isEmpty
        UIView.animate(withDuration: 0.4, delay: .zero, options: .curveEaseIn) {
            canvasView.backgroundColor = .quaternarySystemFill
        }
    }
}
