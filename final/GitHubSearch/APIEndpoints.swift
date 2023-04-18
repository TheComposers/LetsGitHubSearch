import Foundation

struct APIEndpoints {
  static let baseURL = "https://api.github.com/"

  static let repoSearch = "search/repositories?q="
  static let repoDetail = "repos/"
  static func starredList(_ username: String) -> String {
    return "users/\(username)/starred"
  }
}
