import Foundation
import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel

public final class NewEntryReducer: ReducerProtocol {
  @Dependency(\.entriesRepository) var entriesRepository

  public enum Action {
    case onDescriptionChanged(String)
    case onActionInvoked
    case onEntryStarted
    case onEntryStartPersisted(TaskResult<Void>)
    case onEntryCompleted
    case onEntryCompletionPersisted(TaskResult<Void>)
  }

  public struct State: Equatable {
    public var isEligibleToStart = false
    public var description = ""
    public var startDate: Date?
    public var endDate: Date?

    public var isStarted: Bool {
      startDate != nil
    }

    public init() { }

    mutating func reset() {
      isEligibleToStart = false
      description = ""
      startDate = nil
      endDate = nil
    }
  }

  public init() { }
}

public extension NewEntryReducer {
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
        id: (0...1000000).randomElement()!,
        description: state.description,
        start: startDate
      )

      return .task { [self] in
        return await .onEntryStartPersisted(
          TaskResult { _ = try await self.entriesRepository.storeEntry(entry) }
        )
      }

    case .onEntryCompleted:
      guard let startDate = state.startDate else { return .none }

      let endDate = Date()
      state.endDate = endDate

      let entry = Entry(
        id: (0...1000000).randomElement()!,
        description: state.description,
        start: startDate,
        end: endDate
      )

      return .task { [self] in
        return await .onEntryCompletionPersisted(
          TaskResult { _ = try await self.entriesRepository.storeEntry(entry) }
        )
      }

    case .onEntryStartPersisted(.success):
      return .none

    case .onEntryStartPersisted(.failure(let error)):
      print(#function, error)
      return .none

    case .onEntryCompletionPersisted(.success):
      state.reset()
      return .none

    case .onEntryCompletionPersisted(.failure(let error)):
      print(#function, error)
      return .none
    }
  }
}

private extension NewEntryReducer {
  func handleEntryStart(state: inout State) {
    state.startDate = Date()
  }

  func handleEntryCompletion(state: inout State) {
    state.endDate = Date()
  }
}
