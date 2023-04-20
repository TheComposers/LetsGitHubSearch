import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class StargazerTests: XCTestCase {
  func test_get_starred_list_when_load_starred_list_successed() async throws {
    let store = TestStore(
      initialState: Stargazer.State(),
      reducer: Stargazer()
    )

    store.dependencies.stargazerClient.loadStarredList = { _ in StarredListModel.mock }

    await store.send(.loadStarredList) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.success(StarredListModel.mock))) {
      $0.loadingState = .loaded
      $0.searchResult = [
        "apple/Swift",
        "0xq0h3/DynamicRender",
        "pointfreeco/swiftui-navigation"
      ]
    }
  }

  func test_get_error_when_load_starred_list_failed() async throws {
    let store = TestStore(
      initialState: Stargazer.State(),
      reducer: Stargazer()
    )

    store.dependencies.stargazerClient.loadStarredList = { _ in throw APIError.invalidResponse }

    await store.send(.loadStarredList) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.failure(APIError.invalidResponse))) {
      $0.loadingState = .failed
      $0.searchResult = []
    }
  }
}
