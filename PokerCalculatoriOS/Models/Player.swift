import Foundation

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var stake: Double
    var rebuy: Int
}
