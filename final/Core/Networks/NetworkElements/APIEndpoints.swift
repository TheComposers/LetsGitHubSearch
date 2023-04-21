import Foundation

public struct APIEndpoints {
  public static let baseURL = "https://api.github.com"

  public static let repoSearch = "/search/repositories"
  public static let repoDetail = "/repos"
  public static func starredList(_ username: String) -> String {
    return "/users/\(username)/starred"
  }
  public static func star(_ fullname: String) -> String {
    return "/user/starred/\(fullname)"
  }
}
