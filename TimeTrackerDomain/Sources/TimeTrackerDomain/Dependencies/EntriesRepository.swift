import ComposableArchitecture
import TimeTrackerPersistence

private enum EntriesRepositoryKey: DependencyKey {
  static let liveValue: EntriesRepository = DefaultEntriesRepository()
  static var testValue: EntriesRepository = TestEntriesRepository()
}

extension DependencyValues {
  var entriesRepository: EntriesRepository {
    get { self[EntriesRepositoryKey.self] }
    set { self[EntriesRepositoryKey.self] = newValue }
  }
}
