import Foundation

struct RepositoryDetailModel: Sendable, Decodable, Equatable {
  let fullname: String

  enum CodingKeys: String, CodingKey {
    case fullname = "full_name"
  }
}
