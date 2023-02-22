import Foundation
import Combine
import ComposableArchitecture
import TimeTrackerModel

public protocol EntriesRepository {
  var entries: [Entry] { get }
  var entriesPublisher: AnyPublisher<[Entry], Never> { get }
  var runningEntry: Entry? { get }
  @discardableResult func fetchEntries() async throws -> [Entry]
  func storeEntry(_ entry: Entry) async throws -> Entry
  func removeEntry(id: UUID) async throws -> Bool
}

public final class DefaultEntriesRepository: EntriesRepository {
  public var entries: [Entry] {
    entriesSubject.value
  }

  public var entriesPublisher: AnyPublisher<[Entry], Never> {
    entriesSubject
      .map { Array(Set($0)) }
      .removeDuplicates()
      .eraseToAnyPublisher()
  }

  public var runningEntry: Entry? {
    entriesSubject.value.first(where: { !$0.isCompleted })
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
    if let indexOf = entriesSubject.value.firstIndex(of: entry) {
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
      .removeDuplicates()
      .debounce(for: 0.05, scheduler: DispatchQueue.main)
      .sink { [weak self] entries in
        self?.entriesStore.set(entries: entries)
      }
      .store(in: &bag)
  }
}

public final class TestEntriesRepository: EntriesRepository {
  public var runningEntry: Entry?
  public let entries: [Entry] = []
  public let entriesPublisher = PassthroughSubject<[Entry], Never>().eraseToAnyPublisher()
  public init() { }

  public func fetchEntries() async throws -> [Entry] { [] }

  public func storeEntry(_ entry: TimeTrackerModel.Entry) async throws -> Entry {
    fatalError("Not implemented...")
  }

  public func removeEntry(id: UUID) async throws -> Bool {
    fatalError("Not implemented...")
  }
}
