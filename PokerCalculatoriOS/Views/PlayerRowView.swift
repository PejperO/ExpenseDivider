import SwiftUI

struct PlayerRowView: View {
    @Binding var player: Player
    var includeRebuy: Bool

    var body: some View {
        HStack(spacing: 12) {
            TextField("", text: Binding(
                get: { player.name },
                set: { player.name = $0 }
            ))
            .foregroundColor(.white)
            .frame(minWidth: 80, alignment: .leading)

            Spacer()

            TextField("", text: Binding(
                get: { String(format: "%.2f", player.stake) },
                set: { player.stake = Double($0) ?? player.stake }
            ))
            .foregroundColor(.white)
            .multilineTextAlignment(.trailing)
            .frame(width: 60)
            .keyboardType(.decimalPad)

            if includeRebuy {
                Spacer()
                TextField("", text: Binding(
                    get: { String(player.rebuy) },
                    set: { player.rebuy = Int($0) ?? player.rebuy }
                ))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(width: 50)
                .keyboardType(.numberPad)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
