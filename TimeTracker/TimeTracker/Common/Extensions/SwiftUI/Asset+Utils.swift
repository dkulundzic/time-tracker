import SwiftUI

extension SwiftUI.Color {
  init(_ asset: ColorAsset) {
    self.init(asset.name)
  }
}

extension Text {
  func foregroundColor(_ colorAsset: ColorAsset) -> Text {
    foregroundColor(SwiftUI.Color(colorAsset))
  }
}

extension Shape {
  func stroke(_ colorAsset: ColorAsset, lineWidth: CGFloat = 1) -> some View {
    stroke(SwiftUI.Color(colorAsset), lineWidth: lineWidth)
  }
}

extension View {
  func background(_ colorAsset: ColorAsset, alignment: Alignment = .center) -> some View {
    background(SwiftUI.Color(colorAsset), alignment: alignment)
  }

  func foregroundColor(_ colorAsset: ColorAsset) -> some View {
    foregroundColor(SwiftUI.Color(colorAsset))
  }
}
