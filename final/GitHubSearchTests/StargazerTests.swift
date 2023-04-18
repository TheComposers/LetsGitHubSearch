import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class StargazerTests: XCTestCase {
  func testExample() async throws {
    let store = TestStore(
      initialState: Stargazer.State(),
      reducer: Stargazer()
    )

    store.dependencies.stargazerClient.loadStarredList = { _ in [] }

    await store.send(.loadStarredList) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.success([]))) {
      $0.loadingState = .loaded
      $0.searchResult = []
    }
  }
}
