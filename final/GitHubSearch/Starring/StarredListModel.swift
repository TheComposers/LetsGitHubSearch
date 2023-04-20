import Foundation

struct StarredListModel: Sendable, Decodable, Equatable {
  var fullname: String
  enum CodingKeys: String, CodingKey {
    case fullname = "full_name"
  }
}
