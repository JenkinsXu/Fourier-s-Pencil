//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-09.
//

import SwiftUI

struct ExplainationView: View {
    
    let explainationText = """
    Each line you see in this animation is a vector, spinning at a constant rate. But when you connect them tip to tail, incredible things happen: by tuning their rotating frequency and making the last vector's tail draw, you can approximate pretty much any curve you want (like the one you just drew)! The entire animation is driven by something called the Fourier series, which is a beautiful peace of math invented to solve heat equations that drives many of the technologies today.
    """
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(explainationText)
                    .padding()
            }
            .navigationTitle("What is this?")
        }
    }
}
