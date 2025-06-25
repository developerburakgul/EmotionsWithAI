//
//  PersonView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI



struct PersonView: View {
    @StateObject var viewModel: PersonViewModel
    @State var searchQuery: String = ""
    @EnvironmentObject var container: DependencyContainer
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                mainContent
                    .navigationTitle("Person")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(item: $viewModel.selectedPerson) { person in
                        PersonDetailView(viewModel: PersonDetailViewModel(container: container), person: person)
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
        .task {
            await viewModel.loadPersons()
        }

    }
    
    @ViewBuilder
    private var mainContent: some View {
        
        if viewModel.isLoadingPersons {
               ProgressView("Loading...")
           } else if viewModel.shownPersons.isEmpty {
               ContentUnavailableView("Data Not Found", systemImage: "text.magnifyingglass")
           }  else {
            ScrollView {
               
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.shownPersons) { person in
                        PersonCardView(
                            title: person.name,
                            description: person.mostSentiment.label.getStringValue,
                            backgroundColor: Color.brown.opacity(0.2),
                            image: Image(person.mostSentiment.label.getImageNameRemoveBacgkround()),
                            action: {
                                viewModel.userClick(to: person)
                            }
                        )
                        .padding(4)
//                        .onTapGesture {
//                            
//                        }
                    }
                }
                .padding()
            }

        }
    }

}




#Preview("Empty Data") {
    let container = DevPreview.shared.container
    PersonView(viewModel: .init(container: container))
        .previewEnvironmentObject()
        
}

#Preview("Non Empty Data") {
    let container = DevPreview.shared.container
    let mockStorage = MockLocalPersonStorageService()
    container.register(PersonManager.self, service: PersonManager(localPersonStorage: mockStorage))
    return PersonView(viewModel: .init(container: container))
        .previewEnvironmentObject()
        
}

