import Foundation
import ComposableArchitecture

private enum EntriesStoreKey: DependencyKey {
  static var liveValue: EntriesStore = UserDefaultsStore()
  static var testValue: EntriesStore = UserDefaultsStore()
}

extension DependencyValues {
  var entriesStore: EntriesStore {
    get { self[EntriesStoreKey.self] }
    set { self[EntriesStoreKey.self] = newValue }
  }
}
