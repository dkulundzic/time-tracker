import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

@main
struct TimeTrackerApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ZStack(alignment: .bottom) {
          HomeView(
            store: Store(
              initialState: .init(),
              reducer: HomeReducer()
            )
          )

          EntryManagementView(
            store: Store(
              initialState: .init(),
              reducer: EntryManagementReducer()
            )
          )
          .padding()
        }
      }
    }
  }
}
