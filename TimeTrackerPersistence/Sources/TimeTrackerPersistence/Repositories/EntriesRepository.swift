import Foundation
import TimeTrackerModel

public protocol EntriesRepository {
  func fetchEntries() async throws -> [Entry]
  func storeEntry(_ entry: Entry) async throws -> Entry
  func removeEntry(id: Int) async throws -> Bool
}

public final class DefaultEntriesRepository: EntriesRepository {
  private var entries: [Entry] = []

  public func fetchEntries() async throws -> [Entry] {
    entries
  }

  public func storeEntry(_ entry: Entry) async throws -> Entry {
    guard !entries.contains(entry) else {
      return entry
    }
    entries.append(entry)
    return entry
  }

  public func removeEntry(id: Int) async throws -> Bool {
    guard let indexOf = entries.firstIndex(where: { $0.id == id }) else {
      return false
    }
    entries.remove(at: indexOf)
    return true
  }
}

public final class TestEntriesRepository: EntriesRepository {
  public init() { }

  public func fetchEntries() async throws -> [Entry] {
    []
  }

  public func storeEntry(_ entry: TimeTrackerModel.Entry) async throws -> TimeTrackerModel.Entry {
    fatalError("Not implemented...")
  }

  public func removeEntry(id: Int) async throws -> Bool {
    fatalError("Not implemented...")
  }
}
