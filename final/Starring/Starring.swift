import Foundation

import ComposableArchitecture
import Core

public struct Starring: ReducerProtocol {
  public struct State: Equatable {
    @BindableState public var isStarred = false
    public var fullname = ""
    public var loadingState = LoadingState.initial

    public init(isStarred: Bool = false, fullname: String = "", loadingState: LoadingState = LoadingState.initial) {
      self.isStarred = isStarred
      self.fullname = fullname
      self.loadingState = loadingState
    }
  }

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case toggleStarCompleted(TaskResult<String>)
    case checkIfStarred
    case checkStarredCompleted(TaskResult<Bool>)
  }

  @Dependency(\.starringClient) var starringClient

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding(\.$isStarred):
        state.loadingState = .loading
        if state.isStarred {
          return EffectTask.run { [fullname = state.fullname] send in
            let result = await TaskResult { try await starringClient.star(fullname) }
            await send(.toggleStarCompleted(result))
          }
        } else {
          return EffectTask.run { [fullname = state.fullname] send in
            let result = await TaskResult { try await starringClient.unstar(fullname) }
            await send(.toggleStarCompleted(result))
          }
        }

      case .toggleStarCompleted(.success):
        state.loadingState = .loaded
        return .none

      case .checkIfStarred:
        state.loadingState = .loading
        return EffectTask.run { [fullname = state.fullname] send in
          let result = await TaskResult { try await starringClient.checkStarred(fullname) }
          await send(.checkStarredCompleted(result))
        }

      case let .checkStarredCompleted(.success(isStarred)):
        state.loadingState = .loaded
        state.isStarred = isStarred
        return .none

      case let .toggleStarCompleted(.failure(error)), let .checkStarredCompleted(.failure(error)):
        state.loadingState = .failed
        print(error)
        return .none

      case .binding:
        return .none
      }
    }
  }
  public init() { }
}
