import SwiftUI

import ComposableArchitecture

struct RepoDetailView: View {
  let store: StoreOf<RepoDetail>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        if viewStore.loadingState == .loading {
          ProgressView()
        } else {
          if let result = viewStore.searchResult {
            Text(result.fullname)
            Text(result.ownerName)
            Text(result.ownerUserThumbnail)
            Text("\(result.starCount)")
            Text("\(result.forkCount)")
          }
        }
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
