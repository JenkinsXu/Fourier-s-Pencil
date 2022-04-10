//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-09.
//

import SwiftUI

struct VideoVStack<Content: View>: View {
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
