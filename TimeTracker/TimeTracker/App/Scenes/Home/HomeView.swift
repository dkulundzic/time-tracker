import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeView: View {
  let store: StoreOf<HomeReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        ForEach(viewStore.entries) { entry in
          Menu {
#warning("TODO: Localise")
            Button("Delete") {
              viewStore.send(.onDeleteTap(entry))
            }
          } label: {
            ItemView(entry: entry)
          }
        }
      }
      .onFirstAppear {
        viewStore.send(.onFirstAppear)
      }
      .scrollDismissesKeyboard(.immediately)
      .listStyle(PlainListStyle())
      .animation(.default, value: viewStore.entries)
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
