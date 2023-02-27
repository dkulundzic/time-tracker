import Foundation
import Combine
import ComposableArchitecture
import TimeTrackerModel

public protocol EntriesRepository {
  var entriesPublisher: AnyPublisher<[Entry], Never> { get }
  @discardableResult func fetchEntries() async throws -> [Entry]
  func storeEntry(_ entry: Entry) async throws -> Entry
  func removeEntry(id: UUID) async throws -> Bool
}

public final class UserDefaultsEntriesRepository: EntriesRepository {
  public var entriesPublisher: AnyPublisher<[Entry], Never> {
    entriesSubject.eraseToAnyPublisher()
  }

  @Dependency(\.entriesStore) private var entriesStore
  private var bag = Set<AnyCancellable>()
  private let entriesSubject = CurrentValueSubject<[Entry], Never>([])

  public init() {
    entriesSubject.value = entriesStore.get() ?? []
    setupObserving()
  }

  public func fetchEntries() async throws -> [Entry] {
    entriesSubject.value = entriesStore.get() ?? []
    return entriesSubject.value
  }

  public func storeEntry(_ entry: Entry) async throws -> Entry {
    if let indexOf = entriesSubject.value.firstIndex(where: { $0.id == entry.id }) {
      entriesSubject.value[indexOf] = entry
    } else {
      entriesSubject.value.append(entry)
    }
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
      .dropFirst()
      .removeDuplicates()
      .debounce(for: 0.01, scheduler: DispatchQueue.main)
      .sink { [weak self] entries in
        self?.entriesStore.set(entries: entries)
      }
      .store(in: &bag)
  }
}

public final class InMemoryEntriesRepository: EntriesRepository {
  public var entriesPublisher: AnyPublisher<[Entry], Never> {
    entriesSubject.eraseToAnyPublisher()
  }

  private let entriesSubject = CurrentValueSubject<[Entry], Never>([])

  public init() { }

  public func fetchEntries() async throws -> [Entry] {
    entriesSubject.value
  }

  public func storeEntry(_ entry: Entry) async throws -> Entry {
    if let indexOf = entriesSubject.value.firstIndex(where: { $0.id == entry.id }) {
      entriesSubject.value[indexOf] = entry
    } else {
      entriesSubject.value.append(entry)
    }
    return entry
  }

  public func removeEntry(id: UUID) async throws -> Bool {
    guard let indexOf = entriesSubject
      .value
      .firstIndex(where: { $0.id == id }) else {
      return true
    }
    entriesSubject.value.remove(at: indexOf)
    return true
  }
}

public final class TestEntriesRepository: EntriesRepository {
  public var entriesPublisher: AnyPublisher<[Entry], Never> {
    entriesSubject.eraseToAnyPublisher()
  }

  private let entriesSubject: CurrentValueSubject<[Entry], Never>

  public init(
    mockedEntries: [Entry] = []
  ) {
    entriesSubject = CurrentValueSubject<[Entry], Never>(mockedEntries)
  }

  public func fetchEntries() async throws -> [Entry] { [] }

  public func storeEntry(_ entry: Entry) async throws -> Entry { entry }

  public func removeEntry(id: UUID) async throws -> Bool { true }
}
