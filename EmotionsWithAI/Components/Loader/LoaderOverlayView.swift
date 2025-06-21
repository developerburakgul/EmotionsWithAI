//
//  LoaderOverlayView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//
import SwiftUI

struct LoaderOverlayView: View {
    @ObservedObject var loader = LoaderManager.shared

    var body: some View {
        if let loaderType = loader.currentLoader {
            ZStack {
                // Arka plan beyaz ve tüm ekranı kaplasın
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    LottieView(name: loaderType.animationName)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                     Text(loaderType.title)
                         .font(.headline)
                         .foregroundColor(.black)
                }
            }
            .zIndex(9999)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: loader.currentLoader)
        }
    }
}


struct TestLoaderOverlayView: View {
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            LoaderOverlayView()
        }
        .onAppear {
            LoaderManager.shared.show(type: .analyzing)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                LoaderManager.shared.hide()
            }
        }
    }
    
    
}


#Preview {
    TestLoaderOverlayView()
}
