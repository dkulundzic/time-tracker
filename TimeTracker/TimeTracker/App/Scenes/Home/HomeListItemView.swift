import SwiftUI
import TimeTrackerModel

struct HomeListItemView: View {
  let entry: Entry

  var body: some View {
    Text(entry.description)
  }
}

struct HomeListItemView_Previews: PreviewProvider {
  static var previews: some View {
    HomeListItemView(entry: .mock)
  }
}
