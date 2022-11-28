import ComposableArchitecture

struct RepoSearch: ReducerProtocol {
  struct State: Equatable {
    var keyword = ""
    var searchResults = [String]()
  }

  enum Action: Equatable {
    case keywordChanged(String)
    case search
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .keywordChanged(keyword):
      state.keyword = keyword
      return .none

    case .search:
      state.searchResults = self.sampleRepoLists.filter {
        $0.contains(state.keyword)
      }
      return .none
    }
  }

  private let sampleRepoLists = [
    "Swift",
    "SwiftyJSON",
    "SwiftGuide",
    "SwiftterSwift",
  ]
}
