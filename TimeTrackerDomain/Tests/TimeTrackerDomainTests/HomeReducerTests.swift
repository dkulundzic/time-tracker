import XCTest
import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel
@testable import TimeTrackerDomain

@MainActor
final class HomeReducerTests: XCTestCase {
  func testEntriesLoadedOnFirstAppear() async {
    let reducer = HomeReducer()
    let store = TestStore(initialState: HomeReducer.State(), reducer: reducer)
    let entries: [Entry] =  [.mock, .mock]
    store.dependencies.entriesRepository = TestEntriesRepository(mockedEntries: entries)

    await store.send(.onFirstAppear)
    await store.receive(.onEntriesLoaded(entries)) {
      $0.entries = entries.sorted(by: { $0.start > $1.start })
    }
    await store.skipInFlightEffects()
  }

  func testEntryDeletion() async {
    let reducer = HomeReducer()
    let store = TestStore(initialState: HomeReducer.State(), reducer: reducer)
    let entry = Entry.mock

    await store.send(.onDeleteTap(entry))
    await store.receive(.onEntryDeleted(entry))
  }
}
