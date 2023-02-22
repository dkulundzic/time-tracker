import SwiftUI
import TimeTrackerModel

extension HomeView {
  struct ItemView: View {
    let entry: Entry

    var body: some View {
      Text(entry.description)
    }
  }
}

struct HomeListItemView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView.ItemView(entry: .mock)
  }
}
