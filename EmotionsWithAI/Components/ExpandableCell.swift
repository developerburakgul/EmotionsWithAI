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
    let isExpandable: Bool

    init(
        isExpandable: Bool = true,
        isExpanded: Bool = false,
        backgroundColor: Color = Color.gray.opacity(0.1),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.isExpandable = isExpandable
        self.isExpanded = isExpanded
        self.backgroundColor = backgroundColor
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading) {
            button
            detail
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)
        .animation(.default, value: isExpanded)
    }
    
    private func click() {
        if isExpandable {
            isExpanded.toggle()
        }
    }
    
    private var buttonLabel: some View {
        HStack {
            header()
            Spacer()
            if isExpandable {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .tint(UIColor.label.toColor)
            }

        }
    }
    
    private var button: some View {
        Button {
            click()
        } label: {
            buttonLabel
        }
    }
    
    @ViewBuilder
    private var detail: some View {
        if isExpanded   {
            content()
//                .padding(.leading)
        }
    }
}


#Preview {
    ExpandableCell(
        isExpandable: true,
        isExpanded: true,
        backgroundColor: Color.gray.opacity(0.2)) {
            Text("Title")
                .font(.headline)
        } content: {
            VStack(alignment: .leading) {
                Text(verbatim: "Burak")
                Text(verbatim: "Gül")
            }
        }

}
