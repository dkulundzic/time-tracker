import ComposableArchitecture
import TimeTrackerPersistence

private enum EntriesRepositoryKey: DependencyKey {
  static let liveValue: EntriesRepository = InMemoryEntriesRepository()
  static var testValue: EntriesRepository = TestEntriesRepository()
}

public extension DependencyValues {
  var entriesRepository: EntriesRepository {
    get { self[EntriesRepositoryKey.self] }
    set { self[EntriesRepositoryKey.self] = newValue }
  }
}
