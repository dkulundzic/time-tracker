import Foundation
import ComposableArchitecture

private enum TimerFormatterKey: DependencyKey {
  static let liveValue = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .short
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.zeroFormattingBehavior = .dropAll
    return formatter
  }()

  static var testValue: DateComponentsFormatter {
    liveValue
  }
}

extension DependencyValues {
  var timerFormatter: DateComponentsFormatter {
    get { self[TimerFormatterKey.self] }
    set { self[TimerFormatterKey.self] = newValue }
  }
}
