import SwiftUI
import ComposableArchitecture
import Stargazer
import RepositorySearch

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
          reducer: Stargazer()._printChanges()
        )
      )
      .tabItem {
        Text("Star")
      }
    }
  }
}
