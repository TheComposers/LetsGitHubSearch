import XCTest

import ComposableArchitecture
import Factory

@testable import GitHubSearch_final

@MainActor

final class URLSessionTests: XCTestCase {
  override func setUp() async throws {
    try await super.setUp()
    Container.shared = Container()
  }

  func test_get_error_when_urlSession_data_failed() async throws {
    Container.shared.session.register {
      MockURLSession(
        error: APIError.decodingError,
        response: { nil }
      )
    }
    let urlSession = Container.shared.session()

    let expectation = expectation(description: "expect call to throw error")
    do {
      _ = try await urlSession.data(for: URLRequest(url: URL(string: "/dev/null")!))
    } catch {
      if error as! APIError == APIError.decodingError {
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_get_data_when_urlSession_data_successed() async throws {
    let mockData = "hello world".data(using: .utf8)!
    Container.shared.session.register {
      MockURLSession(
        response: { (mockData, URLResponse()) }
      )
    }
    let urlSession = Container.shared.session()

    let (data, _) = try await urlSession.data(for: URLRequest(url: URL(string: "/dev/null")!))

    XCTAssertEqual(data, mockData)
  }
}
