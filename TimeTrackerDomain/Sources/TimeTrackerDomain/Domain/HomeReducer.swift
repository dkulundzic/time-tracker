import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel

public final class HomeReducer: ReducerProtocol {
  @Dependency(\.entriesRepository) var entriesRepository

  public enum Action: Equatable {
    case onFirstAppear
    case onEntriesLoaded([Entry])
    case onDeleteTap(Entry)
    case onEntryDeleted(Entry)
  }

  public struct State: Equatable {
    public var entries: [Entry] = []

    public init() { }
  }

  public init() { }
}

public extension HomeReducer {
  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    switch action {
    case .onFirstAppear:
      return .run { [self] send in
        for await value in self.entriesRepository.entriesPublisher.values {
          await send(
            .onEntriesLoaded(
              value.filter { $0.isCompleted }
            )
          )
        }
      }

    case .onEntriesLoaded(let entries):
      state.entries = entries.sorted(by: { $0.start > $1.start })
      return .none

    case .onDeleteTap(let entry):
      return .task {
        _ = try await self.entriesRepository.removeEntry(id: entry.id)
        return .onEntryDeleted(entry)
      }

    case .onEntryDeleted:
      return .none
    }
  }
}
