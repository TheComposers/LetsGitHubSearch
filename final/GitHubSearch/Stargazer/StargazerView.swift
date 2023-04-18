import SwiftUI

import ComposableArchitecture

struct StargazerView: View {
  let store: StoreOf<Stargazer>

  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEach(viewStore.searchResult, id: \.self) { repo in
          Text(repo)
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
