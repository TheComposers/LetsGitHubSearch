import Foundation

import Factory

extension Container {
  var session: Factory<URLSessionProtocol> {
    self { URLSession.shared }
      .singleton
  }
  var httpClient: Factory<HTTPClientProtocol> {
    self { HTTPClient() }
      .singleton
  }
}
