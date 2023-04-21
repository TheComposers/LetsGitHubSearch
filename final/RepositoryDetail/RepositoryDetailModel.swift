import Foundation

public struct RepositoryDetailModel: Sendable, Decodable, Equatable {
  public let fullname: String
  public let ownerName: String
  public let ownerUserThumbnail: String
  public let starCount: Int
  public let forkCount: Int
  
  enum CodingKeys: String, CodingKey {
    case fullname = "full_name"
    case owner = "owner"
    case ownerName = "login"
    case ownerUserThumbnail = "avatar_url"
    case starCount = "stargazers_count"
    case forkCount = "forks_count"
  }
  
  public init(
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
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.fullname = try container.decode(String.self, forKey: .fullname)
    
    let ownerContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)
    self.ownerName = try ownerContainer.decode(String.self, forKey: .ownerName)
    self.ownerUserThumbnail = try ownerContainer.decode(String.self, forKey: .ownerUserThumbnail)
    
    self.starCount = try container.decode(Int.self, forKey: .starCount)
    self.forkCount = try container.decode(Int.self, forKey: .forkCount)
  }
}

public extension RepositoryDetailModel {
  static let mock = RepositoryDetailModel(
    fullname: "apple/Swift",
    ownerName: "apple",
    ownerUserThumbnail: "none",
    starCount: 5,
    forkCount: 3
  )
}
