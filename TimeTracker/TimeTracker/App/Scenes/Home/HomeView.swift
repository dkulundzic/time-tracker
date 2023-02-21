import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeView: View {
  let store: StoreOf<HomeReducer>
  @State private var newEntryText: String = ""

  var body: some View {
    NavigationStack {
      WithViewStore(store, observe: { $0 }) { viewStore in
        List {
          Section("Start new entry") {
            HomeNewEntryView(
              description: viewStore.binding(
                get: { $0.newEntryText },
                send: { .onNewEntryTextChanged($0) }
              )) {
                viewStore.send(.onNewEntryStarted)
              }
          }

          Section("Entries") {
            HomeListView(entries: viewStore.entries)
          }
        }
        .onChange(of: newEntryText) { text in
          viewStore.send(.onNewEntryTextChanged(text))
        }
      }
      .navigationTitle("Home")
    }
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
