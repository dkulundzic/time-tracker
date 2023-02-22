import Foundation

public struct Entry: Hashable, Identifiable, Codable, CustomStringConvertible {
  public var id: UUID
  public var end: Date?
  public var description: String
  public var start: Date

  public var duration: Duration {
    Duration.seconds(
      DateInterval(
        start: start,
        end: end ?? Date()
      ).duration
    )
  }

  public var isCompleted: Bool {
    end != nil
  }

  public static func ==(lhs: Entry, rhs: Entry) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public init(
    id: UUID,
    description: String,
    start: Date,
    end: Date? = nil
  ) {
    self.id = id
    self.description = description
    self.start = start
    self.end = end
  }
}

public extension Entry {
  static var mock: Entry {
    Entry(
      id: UUID(),
      description: "Work on the assignment",
      start: Date(),
      end: Date().addingTimeInterval(7200)
    )
  }
}
