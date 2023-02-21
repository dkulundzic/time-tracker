import SwiftUI
import TimeTrackerModel

struct HomeListView: View {
  let entries: [Entry]

  var body: some View {
    ForEach(entries) { entry in
      HomeListItemView(entry: entry)
    }
  }
}

struct HomeListView_Previews: PreviewProvider {
  static var previews: some View {
    HomeListView(entries: [.mock])
  }
}
