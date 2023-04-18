import Foundation

struct AppConfig {
  static let githubToken = (Bundle.main.object(forInfoDictionaryKey: "GITHUB_TOKEN") as? String) ?? ""
}
