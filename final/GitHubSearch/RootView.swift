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

      StargazerView(
        store: Store(
          initialState: Stargazer.State(),
          reducer: Stargazer()
        )
      )
      .tabItem {
        Text("Star")
      }
    }
  }
}
