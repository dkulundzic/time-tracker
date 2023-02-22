import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

struct EntryManagementView: View {
  let store: StoreOf<EntryManagementReducer>
  @FocusState private var isTextFieldFocused: Bool

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
#warning("TODO: Localise")
        TextField(
          "New entry",
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
          }

          Button {
            viewStore.send(.onActionInvoked)
          } label: {
            Image(
              systemName: viewStore.startDate != nil ? "stop.fill" : "play.fill"
            )
          }
          .disabled(!viewStore.isEligibleToStart)
          .opacity(viewStore.isEligibleToStart ? 1.0 : 0.0)
          .foregroundColor(Color(Asset.Colors.eggplant))
        }
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(.white)
          .shadow(
            color: Color(Asset.Colors.slateGray).opacity(0.5),
            radius: 4
          )
      )
      .animation(.default, value: viewStore.isEligibleToStart)
      .animation(.default, value: viewStore.isStarted)
      .onFirstAppear { viewStore.send(.onFirstAppeared) }
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
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
