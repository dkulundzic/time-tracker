import XCTest
import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel
@testable import TimeTrackerDomain

@MainActor
final class EntryManagementReducerTests: XCTestCase {
  private let clock = TestClock()

  func testDescriptionChangingFromNonEmptyToEmpty() async {
    let reducer = EntryManagementReducer()
    let store = TestStore(
      initialState: EntryManagementReducer.State(),
      reducer: reducer
    )

    let nonEmptyDescription = "Test"
    await store.send(.onDescriptionChanged(nonEmptyDescription)) {
      $0.description = nonEmptyDescription
      $0.isActionEnabled = true
      $0.isActionVisible = true
    }

    let emptyDescription = ""
    await store.send(.onDescriptionChanged(emptyDescription)) {
      $0.description = emptyDescription
      $0.isActionEnabled = false
      $0.isActionVisible = false
    }
  }

  func testDescriptionChangingFromEmptyToNonEmpty() async {
    let reducer = EntryManagementReducer()
    let store = TestStore(
      initialState: EntryManagementReducer.State(),
      reducer: reducer
    )

    let nonEmptyDescription = "Test"
    await store.send(.onDescriptionChanged(nonEmptyDescription)) {
      $0.description = nonEmptyDescription
      $0.isActionEnabled = true
      $0.isActionVisible = true
    }
  }

  func testEntryStart() async {
    let reducer = EntryManagementReducer()
    let store = TestStore(
      initialState: EntryManagementReducer.State(),
      reducer: reducer
    ) {
      $0.uuid = .incrementing
      $0.date = .constant(.now)
      $0.continuousClock = clock
    }

    let task = await store.send(.onActionInvoked)

    await store.receive(.onEntryStart) {
      let startDate = store.dependencies.date.now
      $0.runningEntry = Entry(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        description: "",
        start: startDate
      )
      $0.elapsedTime = store.dependencies.timerFormatter.string(
        from: startDate,
        to: store.dependencies.date.now
      )
    }
    
    await store.receive(
      .onEntryStartPersisted(.success(store.state.runningEntry!))
    )

    await clock.advance(by: .seconds(1))
    await store.receive(.onEntryTimerTicked)

    await clock.advance(by: .seconds(1))
    await store.receive(.onEntryTimerTicked)

    await task.cancel()
  }

  func testEntryCompletion() async {
    let reducer = EntryManagementReducer()
    let store = TestStore(
      initialState: EntryManagementReducer.State(
        runningEntry: .mockIncomplete
      ),
      reducer: reducer
    ) {
      $0.uuid = .incrementing
      $0.date = .constant(.now)
    }

    let description = "Test description"
    await store.send(.onDescriptionChanged(description)) {
      $0.description = description
      $0.isActionVisible = true
      $0.isActionEnabled = true
    }

    await store.send(.onEntryCompletion) {
      $0.runningEntry?.description = description
      $0.runningEntry?.end = store.dependencies.date.now
    }

    await store.receive(
      .onEntryCompletionPersisted(.success(store.state.runningEntry!))
    ) {
      $0.elapsedTime = nil
      $0.isActionEnabled = false
      $0.isActionVisible = false
      $0.description = ""
      $0.runningEntry = nil
    }
  }

  func testTimerTickWithoutRunningEntry() async {
    let reducer = EntryManagementReducer()
    let store = TestStore(
      initialState: EntryManagementReducer.State(),
      reducer: reducer
    ) {
      $0.uuid = .incrementing
    }

    await store.send(.onEntryTimerTicked)
  }

  func testTimerTickWithRunningEntry() async {
    let entry: Entry = .mockIncomplete
    let reducer = EntryManagementReducer()
    let store = TestStore(
      initialState: EntryManagementReducer.State(runningEntry: entry),
      reducer: reducer
    ) {
      $0.uuid = .incrementing
      $0.date = .constant(.now)
      $0.continuousClock = clock
    }

    await clock.advance(by: .seconds(1))
    await store.send(.onEntryTimerTicked) {
      $0.elapsedTime = "0 s"
    }
  }
}
