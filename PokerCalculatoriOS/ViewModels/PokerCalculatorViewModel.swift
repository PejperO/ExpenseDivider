import SwiftUI
import Combine

class PokerCalculatorViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var inputName: String = ""
    @Published var inputStake: String = ""
    @Published var inputRebuyCount: String = "0"
    @Published var includeRebuy: Bool = false
    @Published var rebuyFeeInput: String = "50"
    @Published var resultTexts: [String] = []
    @Published var errorText: String? = nil

    var primaryColor = Color(red: 0.478, green: 0.039, blue: 0.039)

    private var rebuyFee: Double {
        Double(rebuyFeeInput) ?? 50.0
    }

    func addPlayer() {
        guard !inputName.isEmpty,
              let stakeValue = Double(inputStake),
              let rebuyCount = Int(inputRebuyCount) else { return }
        let player = Player(name: inputName, stake: stakeValue, rebuy: rebuyCount)
        players.append(player)
        inputName = ""; inputStake = ""; inputRebuyCount = "0"
    }

    func calculate() {
        resultTexts.removeAll(); errorText = nil
        guard players.count > 1 else { return }

        let balances: [Double]
        if includeRebuy {
            balances = players.map { p in
                p.stake - rebuyFee - Double(p.rebuy) * rebuyFee
            }
        } else {
            balances = players.map { p in p.stake }
        }

        let total = balances.reduce(0, +)
        if abs(total) > 0.01 {
            let diff = abs(total)
            errorText = total > 0
                ? "Niepoprawny wynik, brakuje \(String(format: "%.2f", diff)) zł"
                : "Niepoprawny wynik, jest ponad \(String(format: "%.2f", diff)) zł"
            return
        }

        var entries = zip(players.map { $0.name }, balances).map { (name: $0.0, bal: $0.1) }
        entries.sort { $0.bal > $1.bal }

        while true {
            entries = entries.filter { abs($0.bal) > 0.01 }
            if entries.isEmpty { break }
            let creditor = entries.first!
            let debtor = entries.last!
            let amount = min(abs(debtor.bal), abs(creditor.bal))
            resultTexts.append("\(debtor.name) daje \(String(format: "%.2f", amount)) zł dla \(creditor.name)")
            entries[0].bal -= amount
            entries[entries.count - 1].bal += amount
            entries.sort { $0.bal > $1.bal }
        }
    }
}
