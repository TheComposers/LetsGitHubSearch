import Foundation

import ComposableArchitecture

struct StarringClient {
  var checkStarred: (String) async throws -> Bool
  var star: (String) async throws -> String
  var unstar: (String) async throws -> String
}

extension DependencyValues {
  var starringClient: StarringClient {
    get { self[StarringClient.self] }
    set { self[StarringClient.self] = newValue }
  }
}

extension StarringClient: DependencyKey {
  static let liveValue = StarringClient(
    checkStarred: { fullname in
      let path = APIEndpoints.baseURL + APIEndpoints.star(fullname)
      let (_, response) = try await HTTPClient.liveValue
        .request(method: .get, path, requiredAuth: true)
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
      }
      if httpResponse.statusCode == 204 {
        return true
      } else if httpResponse.statusCode == 404 {
        return false
      } else {
        throw APIError.invalidResponse
      }
    },
    star: { fullname in
      let path = APIEndpoints.baseURL + APIEndpoints.star(fullname)
      let (_, response) = try await HTTPClient.liveValue
        .request(method: .put, path, requiredAuth: true)

      guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 204 else {
        throw APIError.invalidResponse
      }
      return UUID().uuidString
    },
    unstar: { fullname in
      let path = APIEndpoints.baseURL + APIEndpoints.star(fullname)
      let (_, response) = try await HTTPClient.liveValue
        .request(method: .delete, path, requiredAuth: true)
      guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 204 else {
        throw APIError.invalidResponse
      }
      return UUID().uuidString
    }
  )
}
extension StarringClient: TestDependencyKey {
  static let previewValue = StarringClient(
    checkStarred: { _ in true },
    star: { _ in UUID().uuidString },
    unstar: { _ in UUID().uuidString }
  )

  static let testValue = Self(
    checkStarred: unimplemented("\(Self.self).checkStarred"),
    star: unimplemented("\(Self.self).star"),
    unstar: unimplemented("\(Self.self).unstar")
  )
}
