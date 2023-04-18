import Foundation

extension URLResponse {
  func validateStatus() throws {
    guard let urlResponse = self as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    guard (200..<300) ~= urlResponse.statusCode else {
      throw HTTPError(fromRawValue: urlResponse.statusCode)
    }
  }
}
