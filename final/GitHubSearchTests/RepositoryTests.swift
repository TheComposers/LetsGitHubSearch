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
    store.dependencies.continuousClock = ImmediateClock()

    await store.send(.keywordChanged("Swift")) {
      $0.keyword = "Swift"
    }

    await store.receive(.search) {
      $0.isLoading = true
      $0.requestCount = 1
    }

    await store.receive(.dataLoaded(.success(.mock))) {
      $0.isLoading = false
      $0.searchResults = [
        "Swift",
        "SwiftyJSON",
        "SwiftGuide",
        "SwiftterSwift",
      ]
    }
  }

  func test_requestCount_when_keywordClearedWithinDebounceTime() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )

    store.dependencies.repoSearchClient.search = { _ in .mock }

    let clock = TestClock()
    store.dependencies.continuousClock = clock

    await store.send(.keywordChanged("Swift")) {
      $0.keyword = "Swift"
    }

    await clock.advance(by: .seconds(0.3))

    await store.send(.keywordChanged("")) {
      $0.keyword = ""
      $0.requestCount = 0
      $0.isLoading = false
      $0.searchResults = []
    }
  }
}
