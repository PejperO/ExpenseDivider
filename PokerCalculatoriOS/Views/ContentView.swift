import SwiftUI

struct ContentView: View {
    @StateObject var vm = PokerCalculatorViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("Poker Calculator")
                    .font(.title2)
                    .bold()
                    .foregroundColor(vm.primaryColor)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)

            // Controls
            HStack(spacing: 12) {
                Button("Oblicz") {
                    vm.calculate()
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .buttonStyle(FilledButton(color: vm.primaryColor))

                Toggle(isOn: $vm.includeRebuy) {
                    Text(vm.includeRebuy ? "Z Rebuy" : "Bez Rebuy")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .toggleStyle(SwitchToggleStyle(tint: vm.primaryColor))

                TextField("50", text: $vm.rebuyFeeInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                    .keyboardType(.numberPad)
            }
            .padding()
            .background(Color.black)

            // Add Player
            HStack(spacing: 12) {
                TextField("Imię", text: $vm.inputName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Wynik", text: $vm.inputStake)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
                if vm.includeRebuy {
                    TextField("Rebuy", text: $vm.inputRebuyCount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                }
                Button("Dodaj") {
                    vm.addPlayer()
                }
                .buttonStyle(FilledButton(color: vm.primaryColor))
            }
            .padding()
            .background(Color.black)

            // List Header
            HStack {
                Text("Gracz").frame(minWidth: 80, alignment: .leading).foregroundColor(.gray)
                Spacer()
                Text("Wynik").frame(width: 60, alignment: .trailing).foregroundColor(.gray)
                if vm.includeRebuy {
                    Spacer()
                    Text("Rebuy").frame(width: 50, alignment: .trailing).foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .background(Color.black)

            // Players & Results
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(vm.players.indices, id: \.self) { idx in
                        let p = Binding<Player>(
                            get: { vm.players[idx] },
                            set: { vm.players[idx] = $0 }
                        )
                        PlayerRowView(player: p, includeRebuy: vm.includeRebuy)
                        Divider().background(Color.gray)
                    }

                    // Copy all results
                    if let err = vm.errorText {
                        Text(err)
                            .foregroundColor(.red)
                            .padding()
                    } else if !vm.resultTexts.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vm.resultTexts.joined(separator: "\n"))
                                .foregroundColor(.white)
                                .textSelection(.enabled)
                                .padding(.horizontal)
                            Button("Kopiuj wszystko") {
                                UIPasteboard.general.string = vm.resultTexts.joined(separator: "\n")
                            }
                            .buttonStyle(FilledButton(color: vm.primaryColor))
                            .padding(.top, 4)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Color.black)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Custom button style
struct FilledButton: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
