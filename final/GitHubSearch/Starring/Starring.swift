import Foundation

import ComposableArchitecture

struct Starring: ReducerProtocol {
  struct State: Equatable {
    @BindableState var isStarred = false
    var fullname = ""
  }

  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case toggleStarCompleted(TaskResult<String>)
    case checkIfStarred
    case checkStarredCompleted(TaskResult<Bool>)
  }

  @Dependency(\.starringClient) var starringClient

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding(\.$isStarred):
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
        return .none

      case .checkIfStarred:
        return EffectTask.run { [fullname = state.fullname] send in
          let result = await TaskResult { try await starringClient.checkStarred(fullname) }
          await send(.checkStarredCompleted(result))
        }

      case let .checkStarredCompleted(.success(isStarred)):
        state.isStarred = isStarred
        return .none

      case let .toggleStarCompleted(.failure(error)), let .checkStarredCompleted(.failure(error)):
        print(error)
        return .none

      case .binding:
        return .none
      }
    }
  }
}
