import Foundation

import ComposableArchitecture
import Factory

import Core

struct StargazerClient {
  var loadStarredList: @Sendable (String) async throws -> [StarredListModel]
}

extension DependencyValues {
  var stargazerClient: StargazerClient {
    get { self[StargazerClient.self] }
    set { self[StargazerClient.self] = newValue }
  }
}

extension StargazerClient: DependencyKey {
  static let liveValue = StargazerClient(
    loadStarredList: { username in
      let path = APIEndpoints.baseURL + APIEndpoints.starredList("bbvch13531")
      let httpClient = Container.shared.httpClient()

      return try await httpClient
        .request(method: .get, path, of: [StarredListModel].self)
    }
  )
}
extension StargazerClient: TestDependencyKey {
  static let previewValue = StargazerClient(
    loadStarredList: { _ in [] }
  )
  
  static let testValue = Self(
    loadStarredList: unimplemented("\(Self.self).loadList")
  )
}
