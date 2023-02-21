import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel

public final class HomeReducer: ReducerProtocol {
  @Dependency(\.entriesRepository) var entriesRepository

  public enum Action {
    case onFirstAppear
    case onEntriesLoaded([Entry])
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
      return .run { [self] in
        try await entriesRepository.fetchEntries()
        for await value in self.entriesRepository.entries.values {
          await $0(.onEntriesLoaded(value))
        }
      }
    case .onEntriesLoaded(let entries):
      state.entries = entries
      return .none
    }
  }
}
