import Foundation

struct StarredListModel: Sendable, Decodable, Equatable {
  var fullname: String
  enum CodingKeys: String, CodingKey {
    case fullname = "full_name"
  }
}

extension StarredListModel {
  static let mock = [
    StarredListModel(fullname: "apple/Swift"),
    StarredListModel(fullname: "0xq0h3/DynamicRender"),
    StarredListModel(fullname: "pointfreeco/swiftui-navigation")
  ]
}
