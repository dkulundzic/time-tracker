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
    case onDescriptionChanged(String)
    case onActionInvoked
    case onEntryStarted
    case onEntryStartPersisted(TaskResult<Void>)
    case onEntryCompleted
    case onEntryCompletionPersisted(TaskResult<Void>)
    case onEntryTimerTicked
  }

  public struct State: Equatable {
    public var elapsedTime: String?
    public var isEligibleToStart = false
    public var description = ""
    public var startDate: Date?
    public var endDate: Date?

    public var isStarted: Bool {
      startDate != nil
    }

    public init() { }

    mutating func reset() {
      elapsedTime = nil
      isEligibleToStart = false
      description = ""
      startDate = nil
      endDate = nil
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
    case .onDescriptionChanged(let description):
      state.description = description
      state.isEligibleToStart = !description.isEmpty
      return .none

    case .onActionInvoked:
      return !state.isStarted ? .send(.onEntryStarted) : .send(.onEntryCompleted)

    case .onEntryStarted:
      let startDate = Date()
      state.startDate = startDate

      let entry = Entry(
        id: uuid.callAsFunction(),
        description: state.description,
        start: startDate
      )

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

    case .onEntryCompleted:
      guard let startDate = state.startDate else { return .none }

      let endDate = Date()
      state.endDate = endDate

      let entry = Entry(
        id: uuid.callAsFunction(),
        description: state.description,
        start: startDate,
        end: endDate
      )

      return
        .task { [self] in
          return await .onEntryCompletionPersisted(
            TaskResult { _ = try await self.entriesRepository.storeEntry(entry) }
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
      guard let startDate = state.startDate else { return .none }
      state.elapsedTime = timerFormatter.string(from: startDate, to: Date())
      return .none
    }
  }
}

private extension EntryManagementReducer {
  func handleEntryStart(state: inout State) {
    state.startDate = Date()
  }

  func handleEntryCompletion(state: inout State) {
    state.endDate = Date()
  }
}
