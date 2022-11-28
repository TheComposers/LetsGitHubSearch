struct RepositoryModel: Decodable, Equatable, Sendable {
  var items: [Result]

  struct Result: Decodable, Equatable, Sendable {
    var name: String

    enum CodingKeys: String, CodingKey {
      case name = "full_name"
    }
  }
}

// MARK: - Mock data

extension RepositoryModel {
  static let mock = Self(
    items: [
      RepositoryModel.Result(name: "Swift"),
      RepositoryModel.Result(name: "SwiftyJSON"),
      RepositoryModel.Result(name: "SwiftGuide"),
      RepositoryModel.Result(name: "SwiftterSwift")
    ]
  )
}
