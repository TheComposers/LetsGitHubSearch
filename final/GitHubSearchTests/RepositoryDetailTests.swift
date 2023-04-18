import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class RepositoryDetailTests: XCTestCase {
  func testExample() async throws {
    let store = TestStore(
      initialState: RepoDetail.State(fullname: ""),
      reducer: RepoDetail()
    )

    store.dependencies.repoDetailClient.loadRepoDetail = { _ in .mock }

    await store.send(.loadRepoDetail) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.success(.mock))) {
      $0.loadingState = .loaded
      $0.searchResult = RepositoryDetailModel.mock
    }
  }
}
