import Foundation

import Factory

import Core

extension Container: AutoRegistering {

  public func autoRegister() {
    httpClient.register { HTTPClient() }
  }
}
