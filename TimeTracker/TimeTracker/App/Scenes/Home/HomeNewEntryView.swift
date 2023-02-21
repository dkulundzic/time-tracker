import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeNewEntryView: View {
  let store: StoreOf<NewEntryReducer>
  @State private var description = ""

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
#warning("TODO: Localise")
        TextField("Description", text: $description)

        Button {
          viewStore.send(.onActionInvoked)
        } label: {
          Image(systemName: viewStore.isStarted ? "stop.fill" : "play.fill")
        }
        .opacity(viewStore.isEligibleToStart ? 1.0 : 0.0)
        .animation(.default, value: viewStore.isEligibleToStart)
        .animation(.default, value: viewStore.isStarted)
        .onChange(of: description) { description in
          viewStore.send(.onDescriptionChanged(description))
        }
      }
    }
  }
}

struct HomeNewEntryView_Previews: PreviewProvider {
  static var previews: some View {
    HomeNewEntryView(
      store: Store(
        initialState: .init(),
        reducer: NewEntryReducer()
      )
    )
  }
}
