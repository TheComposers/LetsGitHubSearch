import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class StarringTests: XCTestCase {
  func test_get_starred_result_when_check_starring_repo_successed() async throws {
    let store = TestStore(
      initialState: Starring.State(),
      reducer: Starring()
    )

    store.dependencies.starringClient.checkStarred = { _ in true }

    await store.send(.checkIfStarred) {
      $0.loadingState = .loading
    }
    
    await store.receive(.checkStarredCompleted(.success(true))) {
      $0.loadingState = .loaded
      $0.isStarred = true
    }
  }

  func test_get_starred_result_when_check_starring_repo_failed() async throws {
    let store = TestStore(
      initialState: Starring.State(),
      reducer: Starring()
    )

    store.dependencies.starringClient.checkStarred = { _ in throw APIError.invalidResponse }

    await store.send(.checkIfStarred) {
      $0.loadingState = .loading
    }

    await store.receive(.checkStarredCompleted(.failure(APIError.invalidResponse))) {
      $0.loadingState = .failed
    }
  }

  func test_get_loaded_when_star_repo_successed() async throws {
    let store = TestStore(
      initialState: Starring.State(),
      reducer: Starring()
    )
    let uuid = UUID().uuidString

    store.dependencies.starringClient.checkStarred = { _ in true }
    store.dependencies.starringClient.star = { _ in uuid }


    await store.send(.set(\.$isStarred, true)) {
      $0.isStarred = true
      $0.loadingState = .loading
    }
    await store.receive(.toggleStarCompleted(.success(uuid))) {
      $0.loadingState = .loaded
    }
  }

  func test_get_loaded_when_star_repo_failed() async throws {
    let store = TestStore(
      initialState: Starring.State(),
      reducer: Starring()
    )

    store.dependencies.starringClient.checkStarred = { _ in true }
    store.dependencies.starringClient.star = { _ in throw APIError.invalidResponse }

    await store.send(.set(\.$isStarred, true)) {
      $0.isStarred = true
      $0.loadingState = .loading
    }
    await store.receive(.toggleStarCompleted(.failure(APIError.invalidResponse))) {
      $0.loadingState = .failed
    }
  }

  func test_get_loaded_when_unstar_repo_successed() async throws {
    let store = TestStore(
      initialState: Starring.State(isStarred: true),
      reducer: Starring()
    )
    let uuid = UUID().uuidString

    store.dependencies.starringClient.unstar = { _ in uuid }


    await store.send(.set(\.$isStarred, false)) {
      $0.isStarred = false
      $0.loadingState = .loading
    }
    await store.receive(.toggleStarCompleted(.success(uuid))) {
      $0.loadingState = .loaded
    }
  }

  func test_get_loaded_when_unstar_repo_failed() async throws {
    let store = TestStore(
      initialState: Starring.State(isStarred: true),
      reducer: Starring()
    )

    store.dependencies.starringClient.checkStarred = { _ in true }
    store.dependencies.starringClient.unstar = { _ in throw APIError.invalidResponse }

    await store.send(.set(\.$isStarred, false)) {
      $0.isStarred = false
      $0.loadingState = .loading
    }
    await store.receive(.toggleStarCompleted(.failure(APIError.invalidResponse))) {
      $0.loadingState = .failed
    }
  }
}
