import SwiftUI

import ComposableArchitecture

struct RepoDetailView: View {
  let store: StoreOf<RepoDetail>

  var body: some View {
    VStack {
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
      WithViewStore(store.scope(state: \.starring, action: RepoDetail.Action.starring)) { viewStore in
        ToggleButton(isOn: viewStore.binding(\.$isStarred))
      }
    }
  }
}

struct ToggleButton: View {
  @Binding var isOn: Bool

  var body: some View {
    Button {
      isOn.toggle()
    } label: {
      HStack {
        if isOn {
          Image(systemName: "star.fill")
          Text("Unstar")
        } else {
          Image(systemName: "star")
          Text("Star")
        }
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
