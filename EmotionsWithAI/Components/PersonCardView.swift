////
////  HumanCardView.swift
////  EmotionsWithAI
////
////  Created by Burak Gül on 7.06.2025.
////
//
//import SwiftUI
//
//struct PersonCardView: View {
//    
//    let title: String
//    let description: String
//    let backgroundColor: Color
//    let image: Image
//    let cornerRadius: CGFloat
//    
//    init(
//        title: String,
//        description: String,
//        backgroundColor: Color,
//        image: Image,
//        cornerRadius: CGFloat = 8
//    ) {
//        self.title = title
//        self.description = description
//        self.backgroundColor = backgroundColor
//        self.image = image
//        self.cornerRadius = cornerRadius
//    }
//    
//    var body: some View {
//        HStack(alignment: .center, spacing: 8) {
//            circleImage
//            textView
//            Spacer()
//            rightAccesory
//        }
//        .padding()
//        .background {
//            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
//                   .fill(backgroundColor)
//        }
//    }
//    
//    private var circleImage: some View {
//        image
//            .resizable()
//            .aspectRatio(1.0, contentMode: .fit)
//            .frame(width: 35, height: 35)
//            .clipShape(
//                Circle()
//            )
//    }
//    
//    private var textView: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(title)
//                .font(.title2)
//            
//            Text(description)
//                .font(.caption)
//        }
//    }
//    
//    private var rightAccesory: some View {
//        Image(systemName: "chevron.right")
//            .font(.system(size: 18))
//            .foregroundStyle(Color.black)
//    }
//}
//
//#Preview {
//    PersonCardView(
//        title: "Title",
//        description: "Description",
//        backgroundColor: Color.brown.opacity(0.2),
//        image: Image("Neşe"),
//        cornerRadius: 16
//    )
//}


import SwiftUI
struct PersonCardView: View {
    let title: String
    let description: String
    let backgroundColor: Color
    let image: Image
    let cornerRadius: CGFloat
    let action: () -> Void
    
    @State private var isTapped: Bool = false
    
    init(
        title: String,
        description: String,
        backgroundColor: Color = .white,
        image: Image,
        cornerRadius: CGFloat = 16,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.description = description
        self.backgroundColor = backgroundColor
        self.image = image
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                circleImage
                textView
                Spacer()
                rightAccessory
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
            }
            .scaleEffect(isTapped ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isTapped)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation {
                isTapped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTapped = false
            }
        }
    }
    
    private var circleImage: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 48, height: 48)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(4)
    }
    
    private var textView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }
    
    private var rightAccessory: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.gray)
            .padding(.trailing, 4)
    }
}

#Preview {
    PersonCardView(
        title: "Title",
        description: "This is a sample description for the person card view.",
        backgroundColor: .white,
        image: Image(systemName: "person.fill"),
        action: { print("Card tapped") }
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
