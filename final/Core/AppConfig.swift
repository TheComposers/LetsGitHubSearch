import Foundation

public struct AppConfig {
  public static let githubToken = (Bundle.main.object(forInfoDictionaryKey: "GITHUB_TOKEN") as? String) ?? ""
}
