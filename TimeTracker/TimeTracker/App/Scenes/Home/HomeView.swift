import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeView: View {
  let store: StoreOf<HomeReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ListView(entries: viewStore.entries)
        .onFirstAppear { viewStore.send(.onFirstAppear) }
        .animation(.default, value: viewStore.entries)
        .scrollDismissesKeyboard(.immediately)
    }
    .navigationTitle("Home")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(
      store: Store(
        initialState: .init(),
        reducer: HomeReducer()
      )
    )
  }
}
