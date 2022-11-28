struct RepositoryModel: Decodable, Equatable, Sendable {
  var items: [Result]

  struct Result: Decodable, Equatable, Identifiable, Sendable {
    var name: String
    var id: Int

    enum CodingKeys: String, CodingKey {
      case name = "full_name"
      case id
    }
  }
}

// MARK: - Mock data

extension RepositoryModel {
  static let mock = Self(
    items: [
      RepositoryModel.Result(name: "Swift", id: 1),
      RepositoryModel.Result(name: "SwiftLint", id: 2),
      RepositoryModel.Result(name: "SwiftAlgorithm", id: 3)
    ]
  )
}
