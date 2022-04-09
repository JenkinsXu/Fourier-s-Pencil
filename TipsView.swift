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
            WelcomeView()
            DrawTipsView()
            RedrawTipsView()
            FinishTipsView(dismiss: dismiss)
        }
        .tabViewStyle(.page)
    }
}

struct WelcomeView: View {
    var body: some View {
        Text("Welcome to Fourier's Pencil")
            .font(.title)
            .bold()
    }
}

struct DrawTipsView: View {
    var body: some View {
        VStack {
            Text("Draw")
                .font(.title)
                .bold()
            Text("Express your creativity in one stroke.")
        }
    }
}

struct RedrawTipsView: View {
    var body: some View {
        VStack {
            Text("Redraw")
                .font(.title)
                .bold()
            Text("Tap and redraw if you want.")
        }
    }
}

struct FinishTipsView: View {
    let dismiss: DismissAction
    var body: some View {
        VStack {
            Text("Magic")
                .font(.title)
                .bold()
            Text("Tap \"Finish\" and feel the beauty of math.")
            Button("Start Drawing") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
