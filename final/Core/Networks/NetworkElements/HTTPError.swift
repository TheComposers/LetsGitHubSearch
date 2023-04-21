import Foundation

public enum HTTPError: Int, Error, Equatable {
  case badRequest           = 400
  case unauthorized         = 401
  case forbidden            = 403
  case notFound             = 404
  case methodNotAllowed     = 405
  case requestTimeout       = 408
  case internalServerError  = 500
  case badGateway           = 502
  case serviceUnavailable   = 503
  case gatewayTimeout       = 504
  case unknownHTTPError     = -1

  public init(fromRawValue rawValue: Int) {
    self = HTTPError(rawValue: rawValue) ?? .unknownHTTPError
  }
}

extension HTTPError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badRequest:
      return "HTTPError: Bad Request 400"
    case .unauthorized:
      return "HTTPError: Unauthorized 401"
    case .forbidden:
      return "HTTPError: Forbidden 403"
    case .notFound:
      return "HTTPError: Not Found 404"
    case .methodNotAllowed:
      return "HTTPError: Method Not Allowed 405"
    case .requestTimeout:
      return "HTTPError: Request Timeout 408"
    case .internalServerError:
      return "HTTPError: Internal Server Error 500"
    case .badGateway:
      return "HTTPError: Bad Gateway 502"
    case .serviceUnavailable:
      return "HTTPError: Service Unavailable 503"
    case .gatewayTimeout:
      return "HTTPError: Gateway Timeout 504"
    case .unknownHTTPError:
      return "HTTPError: Unknown HTTPError -1"
    }
  }
}
