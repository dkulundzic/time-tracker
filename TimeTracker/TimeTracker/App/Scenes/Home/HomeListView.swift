import SwiftUI
import TimeTrackerModel

extension HomeView {
  struct ListView: View {
    let entries: [Entry]

    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        ForEach(entries) { entry in
          ItemView(entry: entry)
        }
      }
      .padding()
    }
  }
}

struct HomeListView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView.ListView(entries: [.mock])
  }
}
