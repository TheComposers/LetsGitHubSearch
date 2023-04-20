import XCTest

import ComposableArchitecture
import Factory

@testable import GitHubSearch_final

@MainActor
final class HTTPClientTests: XCTestCase {
  override func setUp() async throws {
    try await super.setUp()
    Container.shared = Container()
  }

  func test_get_starred_result_when_check_starring_repo_failed() async throws {
    Container.shared.session.register {
      MockURLSession(
        error: APIError.decodingError,
        response: { nil }
      )
    }
    
    let httpClient = HTTPClient()
    print(httpClient.session)
    let expectation = expectation(description: "expect call to throw APIError.decodingError")
    do {
      try await httpClient.request(
        method: .get,
        ""
      )
    } catch {
      if error as! APIError == APIError.decodingError {
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_get_starred_result_when_check_starring_repo_successed() async throws {
    let expectedData = "hello world".data(using: .utf8)!
    Container.shared.session.register {
      MockURLSession(
        response: { (expectedData, URLResponse()) }
      )
    }
    let httpClient = HTTPClient()

    let (actualData, _) = try await httpClient.request(
      method: .get,
      ""
    )

    XCTAssertEqual(actualData, expectedData)
  }
}
