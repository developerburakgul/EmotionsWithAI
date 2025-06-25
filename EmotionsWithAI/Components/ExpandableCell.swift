//
//  ExpandableCell.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//


import SwiftUI


struct ExpandableCell<Header: View, Content: View>: View {
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content
    @State private var isExpanded = false

    let backgroundColor: Color

    init(
        backgroundColor: Color = Color.gray.opacity(0.1),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    header()
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.primary)
                }
            }

            if isExpanded {
                content()
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)
        .animation(.default, value: isExpanded)
    }
}

#Preview {
    ExpandableCell(
        backgroundColor: Color.gray.opacity(0.2)) {
            Text("Expandable Title")
                .font(.headline)
        } content: {
            VStack(alignment: .leading) {
                Text("Burak")
                Text("Gül")
            }
        }
}
