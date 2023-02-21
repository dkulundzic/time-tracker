import Foundation
import SwiftUI

struct ViewFirstAppearModifier: ViewModifier {
  let onAppear: () -> Void
  @State private var didAppearOnce = false

  func body(content: Content) -> some View {
    content.onAppear {
      if !didAppearOnce {
        didAppearOnce = true
        onAppear()
      }
    }
  }
}

extension View {
  func onFirstAppearTask(_ onAppear: @Sendable @escaping () async -> Void) -> some View {
    onFirstAppear {
      Task(operation: onAppear)
    }
  }

  func onFirstAppear(_ onAppear: @escaping () -> Void) -> some View {
    modifier(
      ViewFirstAppearModifier(onAppear: onAppear)
    )
  }
}
