import SwiftUI
import TimeTrackerModel

extension HomeView {
  struct ItemView: View {
    let entry: Entry

    var body: some View {
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(entry.description)
            .foregroundColor(Asset.Colors.eggplant)
            .font(.body)
            .fontWeight(.black)

          Text(L10n.homeEntryListItemLoggedTimeFormat(
            entry.duration.formatted())
          )
          .foregroundColor(.black)
          .font(.callout)
          .fontWeight(.medium)
        }
        Spacer()
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
    }
  }
}

struct HomeListItemView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView.ItemView(entry: .mock)
  }
}
