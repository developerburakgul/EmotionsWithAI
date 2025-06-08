//
//  CardView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI


struct CardView: View {
    var title: LocalizedStringResource
    var description: LocalizedStringResource
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.headline)
                .minimumScaleFactor(0.8) // Metni küçültmeye izin verir
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
//                .background(Color.blue)
            
            Text(description)
                .font(.caption)
                .minimumScaleFactor(0.8) // Metni küçültmeye izin verir
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .top)
//                .background(Color.yellow)
        }
        .padding()
        .background(Color.red)
        .cornerRadius(8)
//        .frame(width: 150, height: 150) // Sabit kare boyut
        .clipped() // Taşan içeriği kırpar
    }
}

#Preview {
    HStack {
        CardView(
            title: "Bu Ay Mutlu Hissesdhfjbsdbhfsbsdfsdfjsbhdjfhjhdfbjsdfbjhsdfbhjdiyorsun",
            description: "300 Mesaj"
        )
//        .frame(height: 200) // Örnek bir konteyner genişliği
        
        CardView(
            title: "Kısa",
            description: "Kısa metin"
        )
//        .frame(height: 300) // Aynı genişlik, farklı metin
    }
    .frame(width: 300, height: 150)
    .padding()
}
