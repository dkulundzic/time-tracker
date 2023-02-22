import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeView: View {
  let store: StoreOf<HomeReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        if viewStore.entries.isEmpty {
#warning("TODO: Localise")
          Text("No entries yet tracked.")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.scale.combined(with: .opacity))
        } else {
          List {
            ForEach(viewStore.entries) { entry in
              Menu {
#warning("TODO: Localise")
                Button("Delete", role: .destructive) {
                  viewStore.send(.onDeleteTap(entry))
                }
              } label: {
                ItemView(entry: entry)
              }
            }
          }
          .scrollDismissesKeyboard(.immediately)
          .listStyle(PlainListStyle())
          .transition(.slide)
        }
      }
      .animation(.spring(), value: viewStore.entries)
      .onFirstAppear {
        viewStore.send(.onFirstAppear)
      }
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
