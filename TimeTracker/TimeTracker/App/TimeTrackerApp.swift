import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

@main
struct TimeTrackerApp: App {
  var body: some Scene {
    WindowGroup {
      HomeView(
        store: Store(
          initialState: .init(),
          reducer: HomeReducer()
        )
      )
    }
  }
}
