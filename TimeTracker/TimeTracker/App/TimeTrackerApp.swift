import SwiftUI
import ComposableArchitecture
import TimeTrackerDomain

@main
struct TimeTrackerApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ZStack {
          Color.teal
            .ignoresSafeArea()

          ScrollView {
            LazyVStack {
              EntryManagementView(
                store: Store(
                  initialState: .init(),
                  reducer: EntryManagementReducer()
                )
              )
              .padding(.top, 16)
              .padding(.horizontal, 16)

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
    }
  }
}
