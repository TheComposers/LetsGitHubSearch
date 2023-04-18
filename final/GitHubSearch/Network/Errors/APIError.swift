import Foundation

public enum APIError: Error {
  case invalidURL(String)
  case invalidResponse
  case timeout
  case decodingError
  case transportError(Error)
}

extension APIError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidURL(let url):
      return "APIError: URL is not valid: \(url)"
    case .invalidResponse:
      return "APIError: invalidResponse"
    case .timeout:
      return "APIError: Exceed Timeout"
    case .decodingError:
      return "APIError: Failed to decode"
    case .transportError(let error):
      return "APIError: Transport Error: \(error.localizedDescription)"
    }
  }
}

extension APIError: Equatable {
  public static func == (lhs: APIError, rhs: APIError) -> Bool {
    return lhs.errorDescription == rhs.errorDescription
  }
}
