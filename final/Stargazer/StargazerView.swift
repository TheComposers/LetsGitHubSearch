import SwiftUI

import ComposableArchitecture

import Starring
import RepositoryDetail
import RepositorySearch

public struct StargazerView: View {
  public let store: StoreOf<Stargazer>

  public var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEach(viewStore.searchResult, id: \.self) { repo in
            NavigationLink(
              destination: {
                RepoDetailView(
                  store: Store(
                    initialState: RepoDetail.State(
                      fullname: repo,
                      starring: Starring.State(fullname: repo)
                    ),
                    reducer: RepoDetail()
                  )
                )
              }, label: {
                RepoSearchRow(fullname: repo)
              }
            )
          }
        }
        .task {
          viewStore.send(.loadStarredList)
        }
      }
    }
  }

  public init(store: StoreOf<Stargazer>) {
    self.store = store
  }
}

struct StargazerView_Previews: PreviewProvider {
  static var previews: some View {
    StargazerView(
      store: Store(
        initialState: Stargazer.State(),
        reducer: Stargazer()
      )
    )
  }
}
