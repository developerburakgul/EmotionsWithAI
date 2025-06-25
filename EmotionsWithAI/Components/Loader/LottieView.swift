//
//  LottieView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import SwiftUI

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> some UIView {
        let view = LottieAnimationView(name: name)
        view.loopMode = .loop
        view.play()
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
#Preview {
    LottieView(name: "Animation")
}
