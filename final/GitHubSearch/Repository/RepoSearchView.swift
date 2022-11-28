import SwiftUI

import ComposableArchitecture

struct RepoSearchView: View {
  let store: StoreOf<RepoSearch>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          HStack {
            TextField(
              "Search repo",
              text: Binding(
                get: { viewStore.keyword },
                set: { viewStore.send(.keywordChanged($0)) }
              )
            )
            .textFieldStyle(.roundedBorder)

            Button("Search") {
              viewStore.send(.search)
            }
            .buttonStyle(.borderedProminent)
          }
          .padding()

          Group {
            if(viewStore.isLoading) {
              ProgressView()
              Spacer()
            } else {
              List {
                ForEach(viewStore.searchResults, id: \.self) { repo in
                  Text(repo)
                }
              }
            }
          }
        }
        .navigationTitle("Github Search")
      }
    }
  }
}

struct RepoSearchView_Previews: PreviewProvider {
  static var previews: some View {
    RepoSearchView(
      store: Store(
        initialState: RepoSearch.State(),
        reducer: RepoSearch()
      )
    )
  }
}
