import ComposableArchitecture

struct RepoSearch: ReducerProtocol {
  struct State: Equatable {
    var keyword = ""
    var searchResults = [String]()
    var isLoading = false
  }

  enum Action: Equatable {
    case keywordChanged(String)
    case search
    case dataLoaded(TaskResult<RepositoryModel>)
  }

  @Dependency(\.repoSearchClient) var repoSearchClient

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
        await send(.search)
      }

    case .search:
      state.isLoading = true
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
