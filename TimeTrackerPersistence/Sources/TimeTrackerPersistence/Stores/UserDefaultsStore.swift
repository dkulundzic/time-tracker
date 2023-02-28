import Foundation
import ComposableArchitecture
import TimeTrackerModel

final class UserDefaultsStore: EntriesStore {
  private enum Key: String {
    case entries
  }

  @UserDefaultsCodableStorage(key: Key.entries)
  private var _entries: [Entry]?

  func get() -> [Entry]? {
    _entries
  }

  func set(entries: [Entry]?) {
    _entries = entries
  }
}
