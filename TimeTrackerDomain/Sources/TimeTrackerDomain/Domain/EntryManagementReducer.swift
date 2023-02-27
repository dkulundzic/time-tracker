import Foundation
import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel

public final class EntryManagementReducer: ReducerProtocol {
  @Dependency(\.entriesRepository) private var entriesRepository
  @Dependency(\.continuousClock) private var clock
  @Dependency(\.uuid) private var uuid
  @Dependency(\.timerFormatter) private var timerFormatter


  public enum Action {
    case onFirstAppeared
    case onDescriptionChanged(String)
    case onActionInvoked
    case onRunningEntryDetected(Entry)
    case onEntryStart
    case onEntryStartPersisted(TaskResult<Void>)
    case onEntryCompletion
    case onEntryCompletionPersisted(TaskResult<Void>)
    case onEntryTimerTicked
  }

  public struct State: Equatable {
    var runningEntry: Entry?
    public var description = ""
    public var isActionEnabled = false
    public var isActionVisible = false
    public var elapsedTime: String?

    public var isStarted: Bool {
      runningEntry?.start != nil
    }

    public init() { }

    mutating func reset() {
      elapsedTime = nil
      isActionEnabled = false
      isActionVisible = false
      description = ""
      runningEntry = nil
    }
  }

  private enum TimerID: Hashable { }

  public init() { }
}

public extension EntryManagementReducer {
  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    switch action {
    case .onFirstAppeared:
      guard let alreadyRunningEntry = entriesRepository
        .entries
        .first(where: { !$0.isCompleted })
      else {
        return .none
      }
      return
        .send(
          .onDescriptionChanged(alreadyRunningEntry.description)
        )
        .concatenate(
          with: .send(
            .onRunningEntryDetected(alreadyRunningEntry)
          )
        )

    case .onDescriptionChanged(let description):
      state.description = description
      state.isActionEnabled = true
      state.isActionVisible = true
      return .none

    case .onActionInvoked:
      return !state.isStarted ? .send(.onEntryStart) : .send(.onEntryCompletion)

    case .onRunningEntryDetected(let entry):
      state.runningEntry = entry
      return .send(.onEntryStart)

    case .onEntryStart:
      let entry = Entry(
        id: state.runningEntry?.id ?? uuid.callAsFunction(),
        description: state.runningEntry?.description ?? state.description,
        start: state.runningEntry?.start ?? Date()
      )

      state.runningEntry = entry

      return
        .task { [self] in
          return await .onEntryStartPersisted(
            TaskResult { _ = try await self.entriesRepository.storeEntry(entry) }
          )
        }
        .concatenate(
          with: .run(operation: { send in
            for await _ in self.clock.timer(interval: .seconds(1)) {
              await send(.onEntryTimerTicked)
            }
          })
          .cancellable(id: TimerID.self)
        )

    case .onEntryCompletion:
      guard var runningEntry = state.runningEntry else {
        return .none
      }

      runningEntry.end = Date()

      return
        .task { [self, runningEntry] in
          return await .onEntryCompletionPersisted(
            TaskResult { _ = try await self.entriesRepository.storeEntry(runningEntry) }
          )
        }

    case .onEntryStartPersisted(.success):
      return .none

    case .onEntryStartPersisted(.failure(let error)):
      state.reset()
      return .cancel(id: TimerID.self)

    case .onEntryCompletionPersisted(.success):
      state.reset()
      return .cancel(id: TimerID.self)

    case .onEntryCompletionPersisted(.failure(let error)):
      state.reset()
      return .cancel(id: TimerID.self)

    case .onEntryTimerTicked:
      guard let startDate = state.runningEntry?.start else { return .none }
      state.elapsedTime = timerFormatter.string(from: startDate, to: Date())
      return .none
    }
  }
}
