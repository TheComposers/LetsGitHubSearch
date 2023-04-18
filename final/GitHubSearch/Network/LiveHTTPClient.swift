import Combine
import Foundation

import ComposableArchitecture
import Factory

final class HTTPClient: HTTPClientProtocol {
  @Injected(\.session) var session

  public func request<T: Decodable>(
    method: HTTPMethod,
    _ path: String,
    parameter: [String : String],
    requiredAuth: Bool,
    of type: T.Type
  ) async throws -> T {
    guard var component = URLComponents(string: path.queryEncoding()) else {
      throw APIError.invalidURL(path)
    }

    component.queryItems = parameter.map { dict in
      URLQueryItem(name: dict.key, value: dict.value.queryEncoding())
    }

    guard let url = component.url else {
      throw APIError.invalidURL(path)
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    if requiredAuth {
      request.setValue(AppConfig.githubToken, forHTTPHeaderField: "Authorization")
    }
    request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
    request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

    let (data, response) = try await session.data(for: request)
    try response.validateStatus()

    return try data.decodableData(of: type)
  }
}
