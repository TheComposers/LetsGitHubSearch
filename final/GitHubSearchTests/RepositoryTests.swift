import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class RepositoryTests: XCTestCase {
  func test_user_get_repoSearchResults_when_search() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )
    store.dependencies.repoSearchClient.search = { _ in .mock }

    await store.send(.keywordChanged("Swift")) { store in
      store.keyword = "Swift"
    }

    await store.send(.search) { store in
      store.isLoading = true
    }

    await store.receive(.dataLoaded(.success(.mock))) { store in
      store.isLoading = false
      store.searchResults = [
        "Swift",
        "SwiftyJSON",
        "SwiftGuide",
        "SwiftterSwift",
      ]
    }
  }
}
