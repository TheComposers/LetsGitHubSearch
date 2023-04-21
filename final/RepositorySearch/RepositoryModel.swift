public struct RepositoryModel: Decodable, Equatable, Sendable {
  public var items: [Result]
  
  public struct Result: Decodable, Equatable, Sendable {
    public var fullname: String
    
    enum CodingKeys: String, CodingKey {
      case fullname = "full_name"
    }
  }
}

// MARK: - Mock data

extension RepositoryModel {
  public static let mock = Self(
    items: [
      RepositoryModel.Result(fullname: "Swift"),
      RepositoryModel.Result(fullname: "SwiftyJSON"),
      RepositoryModel.Result(fullname: "SwiftGuide"),
      RepositoryModel.Result(fullname: "SwiftterSwift")
    ]
  )
}
