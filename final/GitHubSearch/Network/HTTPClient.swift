import Foundation

import ComposableArchitecture

extension HTTPClient: TestDependencyKey {
  public static let previewValue = HTTPClient()
  public static let testValue = HTTPClient()
}

extension DependencyValues {
  var httpClient: HTTPClient {
    get { self[HTTPClient.self] }
    set { self[HTTPClient.self]  = newValue }
  }
}

extension HTTPClient: DependencyKey {
  public static let liveValue = HTTPClient()
}
