import Foundation

import ComposableArchitecture

struct RepoDetailClient {
  var loadRepoDetail: @Sendable (String) async throws -> RepositoryDetailModel
}

extension DependencyValues {
  var repoDetailClient: RepoDetailClient {
    get { self[RepoDetailClient.self] }
    set { self[RepoDetailClient.self] = newValue }
  }
}

extension RepoDetailClient: DependencyKey {
  static let liveValue = RepoDetailClient(
    loadRepoDetail: { fullname in
      let path = "https://api.github.com/repos/\(fullname)"
      guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedPath) else {
        throw APIError.invalidURL
      }
      var request = URLRequest(url: url)
      request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
      request.setValue(AppConfig.githubToken, forHTTPHeaderField: "Authorization")
      request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

      let (data, _) = try await URLSession.shared.data(for: request)

      return try JSONDecoder().decode(RepositoryDetailModel.self, from: data)
    }
  )
}
