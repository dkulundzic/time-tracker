import Foundation
import ComposableArchitecture
import TimeTrackerModel

final class UserDefaultsStore: EntriesStore {
  @UserDefaultsCodableStorage(key: .entries)
  private var _entries: [Entry]?

  func get() -> [Entry]? {
    _entries
  }

  func set(entries: [Entry]?) {
    self._entries = entries
  }
}
