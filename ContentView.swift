import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var canvasView = PKCanvasView()
    // TODO: maybe not a state?
    @State private var epicycles = [AnimationGenerator.Epicycle]()
    @State private var keyframes = [[CGPoint]]()
    @State private var showAnimation = false
    @State private var showTips = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var navigationTitleText: String {
        switch horizontalSizeClass {
        case .regular:
            return "Create Your One Stroke Painting"
        case .compact:
            return "In One Stroke"
        default:
            return "Loading"
        }
    }
    
    var body: some View {
        canvasView.drawingPolicy = .anyInput
        return NavigationView {
            DrawingView(canvasView: $canvasView)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding()
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .navigationTitle(navigationTitleText)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing, content: toolbarItems)
                }
                .fullScreenCover(isPresented: $showAnimation, onDismiss: clearCanvas) {
                    AnimatedView(epicycles: $epicycles, keyframes: $keyframes)
                }
                .sheet(isPresented: $showTips) {
                    TipsView()
                }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // NOTE: This is for demo only. In reality, it should only show itself during the first launch
            showTips = true
        }
    }
    
    @ViewBuilder
    private func toolbarItems() -> some View {
        Button(action: showTipsView) {
            Image(systemName: "questionmark.circle")
        }
        .accessibilityLabel("Show tips on how to achieve the best result.")
        
        Button("Redraw", role: .destructive, action: clearCanvas)
        
        Button("Finish", action: finishAndGenerate)
    }
    
    private func clearCanvas() {
        canvasView.drawing = PKDrawing()
        canvasView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4, delay: .zero,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            canvasView.backgroundColor = .systemBackground
        }
    }
    
    private func showTipsView() {
        showTips = true
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
                keyframes = epicycles.toKeyframes()!
                showAnimation = true
            } catch {
                Swift.debugPrint(error.localizedDescription)
            }
        }
    }
}
