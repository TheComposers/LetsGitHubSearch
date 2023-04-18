import Foundation

import Factory

extension Container {
  var session: Factory<URLSessionProtocol> {
    self { URLSession.shared }
  }
}
