import Foundation

import ComposableArchitecture

struct Stargazer: ReducerProtocol {
  struct State: Equatable {
    var username = ""
    var searchResult = [String]()
    var loadingState = LoadingState.initial
  }

  enum Action: Equatable {
    case loadStarredList
    case starredListLoaded(TaskResult<[StarredListModel]>)
  }

  @Dependency(\.stargazerClient) var stargazerClient

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadStarredList:
        state.loadingState = .loading

        return EffectTask.run { [username = state.username] send in
          let result = await TaskResult { try await stargazerClient.loadStarredList(username) }
          await send(.starredListLoaded(result))
        }

      case let .starredListLoaded(.success(result)):
        state.loadingState = .loaded
        state.searchResult = result.map { $0.fullname }
        return .none

      case let .starredListLoaded(.failure(error)):
        state.loadingState = .failed
        print(error)
        return .none
      }
    }
  }
}
