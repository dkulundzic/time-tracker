import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct EntryManagementView: View {
  let store: StoreOf<EntryManagementReducer>

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

        HStack {
          if let elapsedTime = viewStore.elapsedTime {
            Text(elapsedTime)
              .font(.callout)
              .fontWeight(.medium)
              .foregroundColor(Asset.Colors.accentColor)
          }

          Button {
            viewStore.send(.onActionInvoked)
          } label: {
            Image(systemName: viewStore.startDate != nil ? "stop.fill" : "play.fill")
          }
          .disabled(!viewStore.isEligibleToStart)
          .opacity(viewStore.isEligibleToStart ? 1.0 : 0.0)
        }
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(.white)
      )
      .animation(.default, value: viewStore.isEligibleToStart)
      .animation(.default, value: viewStore.isStarted)
    }
  }
}

struct HomeNewEntryView_Previews: PreviewProvider {
  static var previews: some View {
    EntryManagementView(
      store: Store(
        initialState: .init(),
        reducer: EntryManagementReducer()
      )
    )
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.quaternary)
    )
    .previewLayout(.sizeThatFits)
  }
}
