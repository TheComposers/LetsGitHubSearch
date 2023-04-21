import Foundation

public struct StarredListModel: Sendable, Decodable, Equatable {
  public var fullname: String
  enum CodingKeys: String, CodingKey {
    case fullname = "full_name"
  }
}

extension StarredListModel {
  public static let mock = [
    StarredListModel(fullname: "apple/Swift"),
    StarredListModel(fullname: "0xq0h3/DynamicRender"),
    StarredListModel(fullname: "pointfreeco/swiftui-navigation")
  ]
}
