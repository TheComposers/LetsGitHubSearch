import SwiftUI

import ComposableArchitecture

@main
struct GitHubSearchApp: App {
  var body: some Scene {
    WindowGroup {
      RepoSearchView(
        store: Store(
          initialState: RepoSearch.State(),
          reducer: RepoSearch()._printChanges()
        )
      )
    }
  }
}
