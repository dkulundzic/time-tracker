import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

@main
struct TimeTrackerApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        HomeView(
          store: Store(
            initialState: .init(),
            reducer: HomeReducer()
          )
        )
      }
    }
  }
}
