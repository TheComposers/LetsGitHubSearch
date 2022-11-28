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

    await store.send(.keywordChanged("Swift")) {
      $0.keyword = "Swift"
    }

    await store.send(.search) {
      $0.searchResults = [
        "Swift",
        "SwiftyJSON",
        "SwiftGuide",
        "SwiftterSwift",
      ]
    }
  }
}
