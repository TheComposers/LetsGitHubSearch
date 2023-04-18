import SwiftUI

import ComposableArchitecture

struct RepoDetailView: View {
  let store: StoreOf<RepoDetail>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Text(viewStore.fullname)
        Text(viewStore.searchResult)
      }
      .task {
        viewStore.send(.loadRepoDetail)
      }
    }
  }
}

struct RepoDetailView_Previews: PreviewProvider {
  static var previews: some View {
    RepoDetailView(
      store: Store(
        initialState: RepoDetail.State(fullname: ""),
        reducer: RepoDetail()
      )
    )
  }
}
