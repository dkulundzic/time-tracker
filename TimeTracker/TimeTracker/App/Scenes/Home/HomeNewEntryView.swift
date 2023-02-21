import SwiftUI

struct HomeNewEntryView: View {
  @Binding var description: String
  let onStartTap: () -> Void

  var body: some View {
    HStack {
      TextField("Description", text: $description)
      Button(action: onStartTap) {
        Image(systemName: "play.fill")
      }
    }
  }
}

struct HomeNewEntryView_Previews: PreviewProvider {
  static var previews: some View {
    HomeNewEntryView(description: .constant("")) { }
  }
}
