import Foundation

import ComposableArchitecture

struct RepoDetailClient {
  var loadRepoDetail: @Sendable (String) async throws -> RepositoryDetailModel
}

extension DependencyValues {
  var repoDetailClient: RepoDetailClient {
    get { self[RepoDetailClient.self] }
    set { self[RepoDetailClient.self] = newValue }
  }
}

extension RepoDetailClient: DependencyKey {
  static let liveValue = RepoDetailClient(
    loadRepoDetail: { fullname in
      let path = APIEndpoints.baseURL + APIEndpoints.repoDetail + fullname

      return try await HTTPClient.liveValue
        .request(method: .get, path, requiredAuth: true, of: RepositoryDetailModel.self)
    }
  )
}

extension RepoDetailClient: TestDependencyKey {
  static let previewValue = RepoDetailClient(
    loadRepoDetail: { _ in return .mock }
  )
  static let testValue = Self(
    loadRepoDetail: unimplemented("\(Self.self).loadRepoDetail")
  )
}
