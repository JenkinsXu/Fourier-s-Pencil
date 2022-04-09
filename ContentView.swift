import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var canvasView = PKCanvasView()
    @State private var epicycles = [AnimationGenerator.KeyFrame]()
    @State private var showAnimation = false
    
    var body: some View {
        NavigationView {
            DrawingView(canvasView: $canvasView)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding()
                .navigationTitle("Create Your One Stroke Painting")
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .toolbar(content: toolbarItems)
                .sheet(isPresented: $showAnimation) {
                    AnimatedView(epicycles: $epicycles)
                }
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    private func toolbarItems() -> some View {
        Button(action: showTips) {
            Image(systemName: "questionmark.circle")
        }
        .accessibilityLabel("Show tips on how to achieve the best result.")
        
        Button("Redraw", role: .destructive, action: clearCanvas)
        
        Button("Finish", action: finishAndGenerate)
    }
    
    private func clearCanvas() {
        canvasView.undoManager?.undo()
        canvasView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4, delay: .zero,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            canvasView.backgroundColor = .systemBackground
        }
    }
    
    private func showTips() {
        
    }
    
    private func finishAndGenerate() {
        let strokes = canvasView.drawing.strokes
        guard strokes.count == 1 else {
            // TODO: Show dialog
            return
        }
        let path = strokes[0].path
        let animationGenerator = AnimationGenerator(path: path)
        
        Task.detached(priority: .userInitiated) {
            do {
                epicycles = try animationGenerator.epicycles()
                showAnimation = true
            } catch {
                Swift.debugPrint(error.localizedDescription)
            }
        }
    }
}
