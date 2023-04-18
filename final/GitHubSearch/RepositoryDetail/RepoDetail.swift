import Foundation

import ComposableArchitecture

struct RepoDetail: ReducerProtocol {
  struct State: Equatable {
    let fullname: String
    var searchResult = ""
    var isLoading = false
  }

  enum Action: Equatable {
    case loadRepoDetail
    case dataLoaded(TaskResult<RepositoryDetailModel>)
  }

  @Dependency(\.repoDetailClient) var repoDetailClient

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadRepoDetail:
        return EffectTask.run { [fullname = state.fullname] send in
          let result = await TaskResult { try await repoDetailClient.loadRepoDetail(fullname) }
          await send(.dataLoaded(result))
        }
      case let .dataLoaded(.success(result)):
        state.searchResult = result.fullname
        return .none

      case .dataLoaded(.failure):
        return .none
      }
    }
  }
}
