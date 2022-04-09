//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-09.
//

import SwiftUI
import AVKit

struct TipsView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    var body: some View {
        TabView {
            Text("Welcome to Fourier's Pencil!").font(.title).bold()
            TipsTab(withVideoNamed: "draw-tips~dark@2x") {
                Text("Draw").font(.title).bold()
                Text("Express your creativity in one stroke.")
            }
            TipsTab(withVideoNamed: "draw-tips~dark@2x") {
                Text("Redraw").font(.title).bold()
                Text("Tap and redraw if you want.")
            }
            TipsTab(withVideoNamed: "draw-tips~dark@2x") {
                Text("Magic").font(.title).bold()
                Text("Tap \"Finish\" and feel the beauty of math.")
                Button("Start Drawing") {
                    dismiss()
                }.buttonStyle(.borderedProminent)
            }
        }
        .tabViewStyle(.page)
    }
}

struct TipsTab<Content: View>: View {
    private var playerLooper: AVPlayerLooper
    private let player: AVPlayer
    let content: Content
    
    init(withVideoNamed videoResourceName: String, @ViewBuilder content: () -> Content) {
        let url = Bundle.main.url(forResource: videoResourceName, withExtension: "mov")!
        let playerItem = AVPlayerItem(url: url)
        self.player = AVQueuePlayer()
        self.playerLooper = AVPlayerLooper(player: player as! AVQueuePlayer, templateItem: playerItem)
        self.content = content()
    }
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .aspectRatio(16 / 9, contentMode: .fit)
                .onAppear(perform: player.play)
            content
            Spacer()
        }
    }
}
