//
//  NonExpandableCell.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 11.06.2025.
//

import SwiftUI

struct NonExpandableCell<Header: View, Content: View>: View {
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content
    let backgroundColor: Color

    init(
        backgroundColor: Color = Color.gray.opacity(0.1),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.backgroundColor = backgroundColor
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                header()
                Spacer()
            }
            content()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)
    }
}

#Preview {
    NonExpandableCell(
        backgroundColor: Color.gray.opacity(0.2)) {
            Text("Always Visible Title")
                .font(.headline)
        } content: {
            VStack(alignment: .leading) {
                Text("Burak")
                Text("Gül")
            }
        }
}
