import Foundation

import ComposableArchitecture

import Core
import Starring

public struct Stargazer: ReducerProtocol {
  public struct State: Equatable {
    public var username = ""
    public var searchResult = [String]()
    public var loadingState = LoadingState.initial

    public init(
      username: String = "",
      searchResult: [String] = [],
      loadingState: LoadingState = .initial
    ) {
      self.username = username
      self.searchResult = searchResult
      self.loadingState = loadingState
    }
  }

  public enum Action: Equatable {
    case loadStarredList
    case dataLoaded(TaskResult<[StarredListModel]>)
  }

  @Dependency(\.stargazerClient) var stargazerClient

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadStarredList:
        state.loadingState = .loading

        return EffectTask.run { [username = state.username] send in
          let result = await TaskResult { try await stargazerClient.loadStarredList(username) }
          await send(.dataLoaded(result))
        }

      case let .dataLoaded(.success(result)):
        state.loadingState = .loaded
        state.searchResult = result.map { $0.fullname }
        return .none

      case let .dataLoaded(.failure(error)):
        state.loadingState = .failed
        state.searchResult = []
        print(error)
        return .none
      }
    }
  }
  
  public init() { }
}
