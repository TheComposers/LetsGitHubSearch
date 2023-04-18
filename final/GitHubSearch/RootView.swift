import SwiftUI

import ComposableArchitecture

struct RootView: View {
  var body: some View {
    TabView {
      RepoSearchView(
        store: Store(
          initialState: RepoSearch.State(),
          reducer: RepoSearch()._printChanges()
        )
      )
      .tabItem {
        Text("Search")
      }

      StargazerView()
        .tabItem {
          Text("Star")
        }
    }
  }
}
