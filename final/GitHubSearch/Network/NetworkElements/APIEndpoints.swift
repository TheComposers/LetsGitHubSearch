import Foundation

struct APIEndpoints {
  static let baseURL = "https://api.github.com"

  static let repoSearch = "/search/repositories"
  static let repoDetail = "/repos"
  static func starredList(_ username: String) -> String {
    return "/users/\(username)/starred"
  }
  static func star(_ fullname: String) -> String {
    return "/user/starred/\(fullname)"
  }
}
