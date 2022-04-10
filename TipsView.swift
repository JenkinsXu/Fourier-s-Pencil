//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-09.
//

import SwiftUI

struct TipsView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    var body: some View {
        TabView {
            Text("Welcome to Fourier's Pencil!")
                .font(.title).bold()
                .padding().multilineTextAlignment(.center)
            VideoVStack(withVideoNamed: "tips-draw~dark@2x") {
                Text("Draw").font(.title).bold()
                Text("Express your creativity in one stroke.")
            }
            
            VideoVStack(withVideoNamed: "tips-redraw~dark@2x") {
                Text("Redraw").font(.title).bold()
                Text("Tap and redraw if you want.")
            }
            
            // NOTE: The following's onAppear will be called before appearing. It might be a bug from TabView.
            VideoVStack(withVideoNamed: "tips-magic~dark@2x") {
                Text("Magic").font(.title).bold()
                Text("Tap \"Finish\" when you are done, and see the beauty of math.")
                Button("Start Drawing") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 40)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
