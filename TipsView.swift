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
            TipsVStack(withVideoNamed: "tips-draw~dark@2x") {
                Text("Draw").font(.title).bold()
                Text("Express your creativity in one stroke.")
            }
            TipsVStack(withVideoNamed: "tips-redraw~dark@2x") {
                Text("Redraw").font(.title).bold()
                Text("Tap and redraw if you want.")
            }
            TipsVStack(withVideoNamed: "tips-magic~dark@2x", automaticallyAddSpacer: false) {
                Text("Magic").font(.title).bold()
                Text("Tap \"Finish\" and see the beauty of math.")
                Spacer()
                Button("Start Drawing") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 48)
            }
        }
        .tabViewStyle(.page)
    }
}

struct TipsVStack<Content: View>: View {
    private var playerLooper: AVPlayerLooper
    private let player: AVPlayer
    private let automaticallyAddSpcaer: Bool
    let content: Content
    
    init(withVideoNamed videoResourceName: String,
         automaticallyAddSpacer: Bool = true,
         @ViewBuilder content: () -> Content) {
        let url = Bundle.main.url(forResource: videoResourceName, withExtension: "mov")!
        let playerItem = AVPlayerItem(url: url)
        self.player = AVQueuePlayer()
        self.playerLooper = AVPlayerLooper(player: player as! AVQueuePlayer, templateItem: playerItem)
        self.automaticallyAddSpcaer = automaticallyAddSpacer
        self.content = content()
    }
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .aspectRatio(4 / 3, contentMode: .fit)
                .onAppear(perform: player.play)
            content
            if automaticallyAddSpcaer {
                Spacer()
            }
        }
    }
}
