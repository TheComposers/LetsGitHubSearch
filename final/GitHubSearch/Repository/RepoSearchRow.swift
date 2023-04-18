import SwiftUI

struct RepoSearchRow: View {
  let fullname: String

  public init(fullname: String) {
    self.fullname = fullname
  }

  var body: some View {
    Text(fullname)
  }
}

struct RepoSearchRow_Previews: PreviewProvider {
  static var previews: some View {
    RepoSearchRow(fullname: "")
  }
}
