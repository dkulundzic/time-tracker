import TimeTrackerModel
import GRDB

extension Entry: PersistableRecord {
  enum Columns: String, ColumnExpression {
    case id
    case description
    case start
    case end
  }

  public func encode(to container: inout GRDB.PersistenceContainer) throws {
    container[Columns.id] = id
    container[Columns.description] = description
    container[Columns.start] = start
    container[Columns.end] = end
  }
}
