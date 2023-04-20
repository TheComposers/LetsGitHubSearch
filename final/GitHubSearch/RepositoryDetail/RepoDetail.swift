import Foundation

import ComposableArchitecture

struct RepoDetail: ReducerProtocol {
  struct State: Equatable {
    let fullname: String
    var searchResult: RepositoryDetailModel?
    var loadingState = LoadingState.initial
    var starring = Starring.State()
  }

  enum Action: Equatable {
    case loadRepoDetail
    case dataLoaded(TaskResult<RepositoryDetailModel>)
    case starring(Starring.Action)
  }

  @Dependency(\.repoDetailClient) var repoDetailClient

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadRepoDetail:
        state.loadingState = .loading

        return EffectTask.merge(
          .run { [fullname = state.fullname] send in
            let result = await TaskResult { try await repoDetailClient.loadRepoDetail(fullname) }
            await send(.dataLoaded(result))
          },
          .run { send in
            await send(.starring(.checkIfStarred))
          }
        )

      case let .dataLoaded(.success(result)):
        state.loadingState = .loaded
        state.searchResult = result
        return .none

      case let .dataLoaded(.failure(error)):
        print(error)
        state.loadingState = .failed
        return .none

      case .starring:
        return .none
      }
    }

    Scope(state: \.starring, action: /Action.starring) {
      Starring()._printChanges()
    }
  }
}
