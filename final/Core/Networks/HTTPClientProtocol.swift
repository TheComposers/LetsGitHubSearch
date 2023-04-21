import Foundation
public protocol HTTPClientProtocol {
  @discardableResult
  func request<T: Decodable>(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String],
    requiredAuth: Bool,
    of type: T.Type
  ) async throws -> T

  @discardableResult
  func request(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String],
    requiredAuth: Bool
  ) async throws -> (Data, URLResponse)
}

// extension for using default parameter
extension HTTPClientProtocol {
  @discardableResult
  public func request<T: Decodable>(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String] = [:],
    requiredAuth: Bool = false,
    of type: T.Type
  ) async throws -> T {
    try await self.request(method: method, path, parameter: parameter, requiredAuth: requiredAuth, of: type)
  }

  @discardableResult
  public func request(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String] = [:],
    requiredAuth: Bool = false
  ) async throws -> (Data, URLResponse) {
    try await self.request(method: method, path, parameter: parameter, requiredAuth: requiredAuth)
  }
}
