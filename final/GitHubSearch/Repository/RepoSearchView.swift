import SwiftUI

import ComposableArchitecture

struct RepoSearchView: View {
  let store: StoreOf<RepoSearch>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        Group {
          Text("\(viewStore.requestCount)")

          if(viewStore.isLoading) {
            ProgressView()
          } else {
            List {
              ForEach(viewStore.searchResults, id: \.self) { repo in
                Text(repo)
              }
            }
          }
        }
        .searchable(
          text: Binding(
            get: { viewStore.keyword },
            set: { viewStore.send(.keywordChanged($0)) }
          )
        )
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
