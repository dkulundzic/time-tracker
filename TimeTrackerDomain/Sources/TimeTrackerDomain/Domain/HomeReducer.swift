import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel

public final class HomeReducer: ReducerProtocol {
  @Dependency(\.entriesRepository) var entriesRepository

  public enum Action {
    case onFirstAppear
    case onEntriesLoaded(TaskResult<[Entry]>)
    case onNewEntryTextChanged(String)
    case onNewEntryStarted
  }

  public struct State: Equatable {
    public var newEntryText = ""
    public var entries: [Entry]

    public init(entries: [Entry] = [.mock, .mock, .mock]) {
      self.entries = entries
    }
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
      return .none
    case .onNewEntryTextChanged(let text):
      state.newEntryText = text
      return .none
    case .onNewEntryStarted:
      return .none
    case .onEntriesLoaded(.success(let entries)):
      return .none
    case .onEntriesLoaded(.failure(let error)):
      return .none
    }
  }
}
