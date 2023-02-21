import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct HomeNewEntryView: View {
  let store: StoreOf<NewEntryReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
#warning("TODO: Localise")
        TextField(
          "Description",
          text: viewStore.binding(
            get: \.description,
            send: { .onDescriptionChanged($0) }
          )
        )

        Button {
          viewStore.send(.onActionInvoked)
        } label: {
          Image(systemName: viewStore.startDate != nil ? "stop.fill" : "play.fill")
        }
        .disabled(!viewStore.isEligibleToStart)
        .opacity(viewStore.isEligibleToStart ? 1.0 : 0.0)
        .animation(.default, value: viewStore.isEligibleToStart)
        .animation(.default, value: viewStore.isStarted)
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
