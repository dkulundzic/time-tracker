import Foundation

public struct Entry: Equatable, Identifiable {
  public let id: UUID
  public let description: String
  public let start: Date
  public let end: Date?

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
      end: nil
    )
  }
}
