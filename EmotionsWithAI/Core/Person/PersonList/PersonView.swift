//
//  PersonView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI



struct PersonView: View {
    @StateObject var viewModel: PersonViewModel = .init()
    @State var searchQuery: String = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                mainContent
                    .navigationTitle("Person")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(item: $viewModel.selectedPerson) { person in
                        Text(viewModel.selectedPerson?.name ?? "Burak")
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
            }
            .searchable(
                text: $searchQuery,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Enter Name ..."
            )
            .onChange(of: searchQuery) { oldValue, newValue in
                viewModel.userDidSearch(searchQuery)
            }
            
        }

    }
    
    private var mainContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.shownPersons) { person in
                    PersonCardView(
                        title: person.name,
                        description: person.description,
                        backgroundColor: Color.brown.opacity(0.2),
                        image: Image(person.mostSentiment.getImageName())
                    )
                    .padding(4)
                    .onTapGesture {
                        viewModel.userClick(to: person)
                    }
                }
            }
            .padding()
        }
    }

}




#Preview {
    PersonView()
}

#Preview {
    TabBarView()
}
