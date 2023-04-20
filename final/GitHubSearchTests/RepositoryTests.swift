import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class RepositoryTests: XCTestCase {
  func test_user_get_repo_search_results_when_search() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )

    store.dependencies.repoSearchClient.search = { _ in .mock }
    store.dependencies.continuousClock = ImmediateClock()

    await store.send(.set(\.$keyword, "Swift")) {
      $0.keyword = "Swift"
    }

    await store.receive(.search) {
      $0.loadingState = .loading
      $0.requestCount = 1
    }

    await store.receive(.dataLoaded(.success(.mock))) {
      $0.loadingState = .loaded
      $0.searchResults = [
        "Swift",
        "SwiftyJSON",
        "SwiftGuide",
        "SwiftterSwift",
      ]
    }
  }

  func test_user_get_error_when_search_failed() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )

    store.dependencies.repoSearchClient.search = { _ in throw APIError.invalidResponse }
    store.dependencies.continuousClock = ImmediateClock()

    await store.send(.set(\.$keyword, "Swift")) {
      $0.keyword = "Swift"
    }

    await store.receive(.search) {
      $0.loadingState = .loading
      $0.requestCount = 1
    }

    await store.receive(.dataLoaded(.failure(APIError.invalidResponse))) {
      $0.loadingState = .failed
      $0.searchResults = []
    }
  }

  func test_request_count_not_changed_when_keyword_cleared_within_debounce_time() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )

    store.dependencies.repoSearchClient.search = { _ in .mock }

    let clock = TestClock()
    store.dependencies.continuousClock = clock

    await store.send(.set(\.$keyword, "Swift")) {
      $0.keyword = "Swift"
    }

    await clock.advance(by: .seconds(0.3))

    await store.send(.set(\.$keyword, "")) {
      $0.keyword = ""
      $0.requestCount = 0
      $0.loadingState = .initial
      $0.searchResults = []
    }
  }
}
