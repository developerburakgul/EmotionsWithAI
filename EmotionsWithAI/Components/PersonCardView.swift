//
//  HumanCardView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import SwiftUI

struct PersonCardView: View {
    
    let title: String
    let description: String
    let backgroundColor: Color
    let image: Image
    let cornerRadius: CGFloat
    
    init(
        title: String,
        description: String,
        backgroundColor: Color,
        image: Image,
        cornerRadius: CGFloat = 8
    ) {
        self.title = title
        self.description = description
        self.backgroundColor = backgroundColor
        self.image = image
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            circleImage
            textView
            Spacer()
            rightAccesory
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                   .fill(backgroundColor)
        }
    }
    
    private var circleImage: some View {
        image
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: 35, height: 35)
            .clipShape(
                Circle()
            )
    }
    
    private var textView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2)
            
            Text(description)
                .font(.caption)
        }
    }
    
    private var rightAccesory: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 18))
            .foregroundStyle(Color.black)
    }
}

#Preview {
    PersonCardView(
        title: "Title",
        description: "Description",
        backgroundColor: Color.brown.opacity(0.2),
        image: Image("Neşe"),
        cornerRadius: 16
    )
}
