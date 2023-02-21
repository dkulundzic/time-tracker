import ComposableArchitecture
import TimeTrackerPersistence
import TimeTrackerModel

public final class HomeReducer: ReducerProtocol {
  @Dependency(\.entriesRepository) var entriesRepository

  public enum Action {

  }

  public struct State: Equatable {

  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    return .none
  }
}
