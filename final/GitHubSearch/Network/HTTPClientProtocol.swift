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

  func request(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String],
    requiredAuth: Bool
  ) async throws
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

  func request(
    method: HTTPMethod,
    _ path: String,
    parameter: [String: String] = [:],
    requiredAuth: Bool = false
  ) async throws {
    try await self.request(method: method, path, parameter: parameter, requiredAuth: requiredAuth)
  }
}
