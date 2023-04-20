import Foundation

import ComposableArchitecture
import Factory
import XCTestDynamicOverlay

struct RepoSearchClient {
  var search: @Sendable (String) async throws -> RepositoryModel
}

extension DependencyValues {
  var repoSearchClient: RepoSearchClient {
    get { self[RepoSearchClient.self] }
    set { self[RepoSearchClient.self] = newValue }
  }
}

// MARK: - Live API implementation

extension RepoSearchClient: DependencyKey {
  static let liveValue = RepoSearchClient(
    search: { keyword in
      let path = APIEndpoints.baseURL + APIEndpoints.repoSearch
      let httpClient = Container.shared.httpClient()

      return try await httpClient
        .request(method: .get, path, parameter: ["q": keyword], of: RepositoryModel.self)
    }
  )
}

extension RepoSearchClient: TestDependencyKey {
  static let previewValue = Self(
    search: { _ in .mock }
  )

  static let testValue = Self(
    search: unimplemented("\(Self.self).search")
  )
}
