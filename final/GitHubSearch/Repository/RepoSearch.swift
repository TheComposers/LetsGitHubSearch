import ComposableArchitecture

struct RepoSearch: ReducerProtocol {
  struct State: Equatable {
    var keyword = ""
    var searchResults = [String]()
    var isLoading = false
    var requestCount = 0
  }

  enum Action: Equatable {
    case keywordChanged(String)
    case search
    case dataLoaded(TaskResult<RepositoryModel>)
  }

  @Dependency(\.repoSearchClient) var repoSearchClient
  @Dependency(\.continuousClock) var clock

  private enum SearchDebounceId {}

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .keywordChanged(keyword):
      state.keyword = keyword

      if keyword == "" {
        state.isLoading = false
        state.searchResults = []
        return .none
      }

      return .run { send in
        try await self.clock.sleep(for: .seconds(0.5))
        await send(.search)
      }
      .cancellable(id: SearchDebounceId.self, cancelInFlight: true)

    case .search:
      state.isLoading = true
      state.requestCount += 1
      return Effect.run { [keyword = state.keyword] send in
        let result = await TaskResult { try await repoSearchClient.search(keyword) }
        await send(.dataLoaded(result))
      }

    case let .dataLoaded(.success(repositoryModel)):
      state.isLoading = false
      state.searchResults = repositoryModel.items.map { $0.name }
      return .none

    case .dataLoaded(.failure):
      state.isLoading = false
      state.searchResults = []
      return .none
    }
  }
}
