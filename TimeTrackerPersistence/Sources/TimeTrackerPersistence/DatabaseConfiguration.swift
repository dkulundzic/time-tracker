import Foundation

struct DatabaseConfiguration {
  static let databaseName = "time-tracker.sqlite"

  static let url: URL =
    FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask)
    .first!
    .appending(path: databaseName)
}
