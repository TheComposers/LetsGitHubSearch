import Foundation

import ComposableArchitecture

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
      return try await HTTPClient.liveValue
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
