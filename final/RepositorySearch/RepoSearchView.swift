import SwiftUI

import ComposableArchitecture

import Starring
import RepositoryDetail

public struct RepoSearchView: View {
  public let store: StoreOf<RepoSearch>

  public init(store: StoreOf<RepoSearch>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        Group {
          Text("\(viewStore.requestCount)")
          Spacer()

          if(viewStore.loadingState == .loading) {
            ProgressView()
          } else {
            List {
              ForEach(viewStore.searchResults, id: \.self) { repo in
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
          }
          Spacer()
        }
        .searchable(text: viewStore.binding(\.$keyword))
        .navigationTitle("Github Search")
      }
    }
  }
}

public struct RepoSearchView_Previews: PreviewProvider {
  public static var previews: some View {
    RepoSearchView(
      store: Store(
        initialState: RepoSearch.State(),
        reducer: RepoSearch()
      )
    )
  }
}
