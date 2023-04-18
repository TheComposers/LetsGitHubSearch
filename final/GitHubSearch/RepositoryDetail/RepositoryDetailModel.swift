import Foundation

struct RepositoryDetailModel: Sendable, Decodable, Equatable {
  let fullname: String
  let ownerName: String
  let ownerUserThumbnail: String
  let starCount: Int
  let forkCount: Int
  
  enum CodingKeys: String, CodingKey {
    case fullname = "full_name"
    case owner = "owner"
    case ownerName = "login"
    case ownerUserThumbnail = "avatar_url"
    case starCount = "stargazers_count"
    case forkCount = "forks_count"
  }
  
  init(
    fullname: String,
    ownerName: String,
    ownerUserThumbnail: String,
    starCount: Int,
    forkCount: Int
  ) {
    self.fullname = fullname
    self.ownerName = ownerName
    self.ownerUserThumbnail = ownerUserThumbnail
    self.starCount = starCount
    self.forkCount = forkCount
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.fullname = try container.decode(String.self, forKey: .fullname)
    
    let ownerContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)
    self.ownerName = try ownerContainer.decode(String.self, forKey: .ownerName)
    self.ownerUserThumbnail = try ownerContainer.decode(String.self, forKey: .ownerUserThumbnail)
    
    self.starCount = try container.decode(Int.self, forKey: .starCount)
    self.forkCount = try container.decode(Int.self, forKey: .forkCount)
  }
}

extension RepositoryDetailModel {
  static let mock = RepositoryDetailModel(
    fullname: "apple/Swift",
    ownerName: "apple",
    ownerUserThumbnail: "none",
    starCount: 5,
    forkCount: 3
  )
}
