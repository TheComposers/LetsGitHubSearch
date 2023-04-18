import Foundation

import ComposableArchitecture

struct StargazerClient {
  var loadStarredList: @Sendable (String) async throws -> [StargazerListModel]
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
      guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: encodedPath) else {
        throw APIError.invalidURL
      }
      let (data, _) = try await URLSession.shared.data(from: url)
//      print(String(data: data, encoding: .utf8))
      return try JSONDecoder().decode([StargazerListModel].self, from: data)
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
