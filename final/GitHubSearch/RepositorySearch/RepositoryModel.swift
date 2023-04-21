struct RepositoryModel: Decodable, Equatable, Sendable {
  var items: [Result]
  
  struct Result: Decodable, Equatable, Sendable {
    var fullname: String
    
    enum CodingKeys: String, CodingKey {
      case fullname = "full_name"
    }
  }
}

// MARK: - Mock data

extension RepositoryModel {
  static let mock = Self(
    items: [
      RepositoryModel.Result(fullname: "Swift"),
      RepositoryModel.Result(fullname: "SwiftyJSON"),
      RepositoryModel.Result(fullname: "SwiftGuide"),
      RepositoryModel.Result(fullname: "SwiftterSwift")
    ]
  )
}
