import Foundation
@testable import Core

class MockURLSession: URLSessionProtocol {
  public var error: Error?
  public var response: () -> (Data, URLResponse)?

  public init(error: Error? = nil, response: @escaping () -> (Data, URLResponse)?) {
    self.error = error
    self.response = response
  }

  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    if let error {
      throw error
    }
    return response() ?? (Data(), URLResponse())
  }
}
