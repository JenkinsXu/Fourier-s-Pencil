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
            VideoVStack(withVideoNamed: "tips-draw~dark@2x") {
                Text("Draw").font(.title).bold()
                Text("Express your creativity in one stroke.")
            }
            VideoVStack(withVideoNamed: "tips-redraw~dark@2x") {
                Text("Redraw").font(.title).bold()
                Text("Tap and redraw if you want.")
            }
            VideoVStack(withVideoNamed: "tips-magic~dark@2x", automaticallyAddSpacer: false) {
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
