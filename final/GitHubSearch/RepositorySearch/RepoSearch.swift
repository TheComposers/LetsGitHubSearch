import ComposableArchitecture
import Core
struct RepoSearch: ReducerProtocol {
  struct State: Equatable {
    @BindingState var keyword = ""
    var searchResults = [String]()
    var loadingState = LoadingState.initial
    var requestCount = 0
  }

  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case search
    case dataLoaded(TaskResult<RepositoryModel>)
  }

  @Dependency(\.repoSearchClient) var repoSearchClient
  @Dependency(\.continuousClock) var clock

  private enum SearchDebounceId {}
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.$keyword):
        if state.keyword == "" {
          state.loadingState = .initial
          state.searchResults = []
          return .cancel(id: SearchDebounceId.self)
        }

        return .run { send in
          try await self.clock.sleep(for: .seconds(0.5))
          await send(.search)
        }
        .cancellable(id: SearchDebounceId.self, cancelInFlight: true)

      case .search:
        state.loadingState = .loading
        state.requestCount += 1
        return EffectTask.run { [keyword = state.keyword] send in
          let result = await TaskResult { try await repoSearchClient.search(keyword) }
          await send(.dataLoaded(result))
        }

      case let .dataLoaded(.success(repositoryModel)):
        state.loadingState = .loaded
        state.searchResults = repositoryModel.items.map { $0.fullname }
        return .none

      case .dataLoaded(.failure):
        state.loadingState = .failed
        state.searchResults = []
        return .none

      case .binding:
        return .none
      }
    }
  }
}
