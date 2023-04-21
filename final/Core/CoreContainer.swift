import Foundation
import Factory

extension Container {
  var session: Factory<URLSessionProtocol> {
    self { URLSession.shared }
      .singleton
  }
  public var httpClient: Factory<HTTPClientProtocol> {
    self { HTTPClient() }
      .singleton
  }
}
