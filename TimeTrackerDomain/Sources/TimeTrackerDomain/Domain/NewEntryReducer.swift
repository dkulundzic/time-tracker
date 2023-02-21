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
    case onEntryCompleted
    case onEntryUpdated
  }

  public struct State: Equatable {
    public var isEligibleToStart = false
    public var description = ""
    public var startDate: Date?
    public var endDate: Date?

    public var isStarted: Bool {
      startDate != nil
    }

    public var isCompleted: Bool {
      endDate != nil
    }

    public init() { }
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
      let endDate = startDate.addingTimeInterval(7200)
      let entry = Entry(
        id: (0...1000000).randomElement()!,
        description: state.description,
        start: startDate,
        end: endDate
      )

      return .task { [self] in
        try await self.entriesRepository.storeEntry(entry)
        return .onEntryUpdated
      }

    case .onEntryCompleted:
      return .none

    case .onEntryUpdated:
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
