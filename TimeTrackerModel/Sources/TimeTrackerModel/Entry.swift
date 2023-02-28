import Foundation

public struct Entry: Hashable, Identifiable, Codable, CustomStringConvertible {
  public let id: UUID
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
    let id = UUID()
    return Entry(
      id: id,
      description: id.uuidString,
      start: Date(),
      end: Date().addingTimeInterval(
        TimeInterval(
          (0...14400).randomElement()!
        )
      )
    )
  }

  static var mockIncomplete: Entry {
    let id = UUID()
    return Entry(
      id: id,
      description: id.uuidString,
      start: Date(),
      end: nil
    )
  }
}
