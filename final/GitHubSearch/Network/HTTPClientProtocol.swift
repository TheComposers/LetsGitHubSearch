import Foundation

public protocol HTTPClientProtocol {
  func request<T: Decodable>(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String],
    requiredAuth: Bool,
    of type: T.Type
  ) async throws -> T
}

// extension for using default parameter
extension HTTPClientProtocol {
  public func request<T: Decodable>(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String] = [:],
    requiredAuth: Bool = false,
    of type: T.Type
  ) async throws -> T {
    try await self.request(method: method, path, parameter: parameter, requiredAuth: requiredAuth, of: type)
  }
}
