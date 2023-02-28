import Foundation
import TimeTrackerModel

@propertyWrapper
public struct UserDefaultsStorage<T, Key> where Key: RawRepresentable<String> {
  private let key: Key
  private let defaultValue: T?
  private let userDefaults: UserDefaults

  public init(
    key: Key,
    defaultValue: T? = nil,
    userDefaults: UserDefaults = .standard
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults
  }

  public var wrappedValue: T? {
    get {
      userDefaults.object(forKey: key.rawValue) as? T
    }
    set {
      userDefaults.set(newValue, forKey: key.rawValue)
    }
  }
}

@propertyWrapper
public struct UserDefaultsCodableStorage<T: Codable, Key> where Key: RawRepresentable<String> {
  private lazy var decoder = JSONDecoder()
  private lazy var encoder = JSONEncoder()
  private let key: Key
  private let defaultValue: T?
  private let userDefaults: UserDefaults

  public init(
    key: Key,
    defaultValue: T? = nil,
    userDefaults: UserDefaults = UserDefaults(suiteName: "time-tracker-storage")!
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults
  }

  public var wrappedValue: T? {
    mutating get {
      guard let data = userDefaults.object(forKey: key.rawValue) as? Data else {
        return nil
      }
      return try? decoder.decode(T.self, from: data)
    }
    set {
      let data = try? encoder.encode(newValue)
      userDefaults.set(data, forKey: key.rawValue)
    }
  }
}
