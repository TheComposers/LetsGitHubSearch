import Foundation

public extension String {
  func queryEncoding() -> String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
  }
}
