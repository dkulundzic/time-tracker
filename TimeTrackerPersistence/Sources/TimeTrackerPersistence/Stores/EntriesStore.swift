import Foundation
import ComposableArchitecture
import TimeTrackerModel

protocol EntriesStore {
  func get() -> [Entry]?
  func set(entries: [Entry]?)
}
