import SwiftUI

import ComposableArchitecture

struct StargazerView: View {
  let store: StoreOf<Stargazer>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEach(viewStore.searchResult, id: \.self) { repo in
            NavigationLink(
              destination: {
                RepoDetailView(
                  store: Store(
                    initialState: RepoDetail.State(fullname: repo),
                    reducer: RepoDetail()
                  )
                )
              }, label: {
                RepoSearchRow(fullname: repo)
              }
            )
          }
        }
      }
      .task {
        viewStore.send(.loadStarredList)
      }
    }
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
