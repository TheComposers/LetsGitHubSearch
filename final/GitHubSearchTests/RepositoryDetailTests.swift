import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class RepositoryDetailTests: XCTestCase {
  func test_get_unstarred_repo_detail_when_load_successed() async throws {
    let store = TestStore(
      initialState: RepoDetail.State(
        fullname: RepositoryDetailModel.mock.fullname,
        starring: Starring.State(fullname: RepositoryDetailModel.mock.fullname)
      ),
      reducer: RepoDetail()
    )

    store.dependencies.repoDetailClient.loadRepoDetail = { _ in .mock }
    store.dependencies.starringClient.checkStarred = { _ in false }

    await store.send(.loadRepoDetail) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.success(.mock))) {
      $0.loadingState = .loaded
      $0.searchResult = RepositoryDetailModel.mock
    }

    await store.receive(.starring(.checkIfStarred)) {
      $0.loadingState = .loading
      $0.starring.loadingState = .loading
    }

    await store.receive(.starring(.checkStarredCompleted(.success(false)))) {
      $0.loadingState = .loaded
      $0.starring.loadingState = .loaded
    }
  }

  func test_get_starred_repo_detail_when_load_successed() async throws {
    let store = TestStore(
      initialState: RepoDetail.State(
        fullname: RepositoryDetailModel.mock.fullname,
        starring: Starring.State(fullname: RepositoryDetailModel.mock.fullname)
      ),
      reducer: RepoDetail()
    )

    store.dependencies.repoDetailClient.loadRepoDetail = { _ in .mock }
    store.dependencies.starringClient.checkStarred = { _ in true }

    await store.send(.loadRepoDetail) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.success(.mock))) {
      $0.loadingState = .loaded
      $0.searchResult = RepositoryDetailModel.mock
    }

    await store.receive(.starring(.checkIfStarred)) {
      $0.loadingState = .loading
      $0.starring.loadingState = .loading
    }

    await store.receive(.starring(.checkStarredCompleted(.success(true)))) {
      $0.loadingState = .loaded
      $0.starring.loadingState = .loaded
      $0.starring.isStarred = true
    }
  }

  func test_get_error_when_load_detail_failed() async throws {
    let store = TestStore(
      initialState: RepoDetail.State(
        fullname: RepositoryDetailModel.mock.fullname,
        starring: Starring.State(fullname: RepositoryDetailModel.mock.fullname)
      ),
      reducer: RepoDetail()
    )

    store.dependencies.repoDetailClient.loadRepoDetail = { _ in throw APIError.invalidResponse }
    store.dependencies.starringClient.checkStarred = { _ in true }

    await store.send(.loadRepoDetail) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.failure(APIError.invalidResponse))) {
      $0.loadingState = .failed
      $0.searchResult = nil
    }

    await store.receive(.starring(.checkIfStarred)) {
      $0.loadingState = .loading
      $0.starring.loadingState = .loading
    }

    await store.receive(.starring(.checkStarredCompleted(.success(true)))) {
      $0.loadingState = .loaded
      $0.starring.loadingState = .loaded
      $0.starring.isStarred = true
    }
  }

  func test_get_error_when_check_starred_failed() async throws {
    let store = TestStore(
      initialState: RepoDetail.State(
        fullname: RepositoryDetailModel.mock.fullname,
        starring: Starring.State(fullname: RepositoryDetailModel.mock.fullname)
      ),
      reducer: RepoDetail()
    )

    store.dependencies.repoDetailClient.loadRepoDetail = { _ in .mock }
    store.dependencies.starringClient.checkStarred = { _ in throw APIError.invalidResponse }

    await store.send(.loadRepoDetail) {
      $0.loadingState = .loading
    }

    await store.receive(.dataLoaded(.success(.mock))) {
      $0.loadingState = .loaded
      $0.searchResult = RepositoryDetailModel.mock
    }

    await store.receive(.starring(.checkIfStarred)) {
      $0.loadingState = .loading
      $0.starring.loadingState = .loading
    }

    await store.receive(.starring(.checkStarredCompleted(.failure(APIError.invalidResponse)))) {
      $0.loadingState = .failed
      $0.starring.loadingState = .failed
    }
  }
}
