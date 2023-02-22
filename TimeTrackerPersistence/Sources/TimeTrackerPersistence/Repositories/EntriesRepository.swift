import Foundation
import Combine
import ComposableArchitecture
import TimeTrackerModel

public protocol EntriesRepository {
  var entries: AnyPublisher<[Entry], Never> { get }
  func fetchEntries() async throws
  func storeEntry(_ entry: Entry) async throws -> Entry
  func removeEntry(id: UUID) async throws -> Bool
}

public final class DefaultEntriesRepository: EntriesRepository {
  public var entries: AnyPublisher<[Entry], Never> {
    entriesSubject
      .removeDuplicates()
      .eraseToAnyPublisher()
  }

  @Dependency(\.entriesStore) private var entriesStore
  private var bag = Set<AnyCancellable>()
  private let entriesSubject = CurrentValueSubject<[Entry], Never>([])

  public init() {
    setupObserving()
  }

  public func fetchEntries() async throws {
    entriesSubject.value = entriesStore.get() ?? []
  }

  public func storeEntry(_ entry: Entry) async throws -> Entry {
    guard !entriesSubject.value.contains(entry) else {
      return entry
    }
    entriesSubject.value.append(entry)
    return entry
  }

  public func removeEntry(id: UUID) async throws -> Bool {
    guard let indexOf = entriesSubject
      .value
      .firstIndex(where: { $0.id == id }) else {
      return false
    }
    entriesSubject.value.remove(at: indexOf)
    return true
  }

  private func setupObserving() {
    entriesSubject
      .removeDuplicates()
      .debounce(for: 0.05, scheduler: DispatchQueue.main)
      .sink { [weak self] entries in
        self?.entriesStore.set(entries: entries)
      }
      .store(in: &bag)
  }
}

public final class TestEntriesRepository: EntriesRepository {
  public let entries = PassthroughSubject<[Entry], Never>().eraseToAnyPublisher()
  public init() { }

  public func fetchEntries() async throws { }

  public func storeEntry(_ entry: TimeTrackerModel.Entry) async throws -> Entry {
    fatalError("Not implemented...")
  }

  public func removeEntry(id: UUID) async throws -> Bool {
    fatalError("Not implemented...")
  }
}
