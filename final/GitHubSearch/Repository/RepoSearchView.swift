import SwiftUI

import ComposableArchitecture

struct RepoSearchView: View {
  let store: StoreOf<RepoSearch>

  var body: some View {
    WithViewStore(self.store) { viewStore in
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

          List {
            ForEach(viewStore.searchResults, id: \.self) {
              Text($0)
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
