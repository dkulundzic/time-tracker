import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeView: View {
  let store: StoreOf<HomeReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        ForEach(viewStore.entries) { entry in
          ItemView(entry: entry)
        }
      }
      .onFirstAppear {
        viewStore.send(.onFirstAppear)
      }
      .listStyle(PlainListStyle())
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
