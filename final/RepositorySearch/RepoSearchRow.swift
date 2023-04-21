import SwiftUI

public struct RepoSearchRow: View {
  public let fullname: String

  public init(fullname: String) {
    self.fullname = fullname
  }

  public var body: some View {
    Text(fullname)
  }
}

public struct RepoSearchRow_Previews: PreviewProvider {
  public static var previews: some View {
    RepoSearchRow(fullname: "")
  }
}
