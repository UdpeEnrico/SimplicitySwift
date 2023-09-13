import SwiftUI

struct ContentView: View {
    @State private var secretNumber = Int.random(in: 1...100)
    @State private var guess = ""
    @State private var message = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Adivinhe o Número")
                .font(.largeTitle)
                .padding()
            
            Text("Tente adivinhar o número entre 1 e 100.")
                .font(.headline)
                .padding()
            
            TextField("Digite seu palpite", text: $guess)
                .keyboardType(.numberPad)
                .font(.title)
                .padding()
            
            Button("Verificar", action: checkGuess)
                .font(.title)
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Resultado"),
                        message: Text(message),
                        dismissButton: .default(Text("Novo Jogo")) {
                            resetGame()
                        }
                    )
                }
        }
    }
    
    func checkGuess() {
        guard let userGuess = Int(guess) else {
            message = "Por favor, insira um número válido."
            showAlert = true
            return
        }
        
        if userGuess == secretNumber {
            message = "Parabéns! Você adivinhou o número \(secretNumber)."
        } else if userGuess < secretNumber {
            message = "Tente um número maior."
        } else {
            message = "Tente um número menor."
        }
        
        showAlert = true
    }
    
    func resetGame() {
        secretNumber = Int.random(in: 1...100)
        guess = ""
        message = ""
    }
}
struct NumberGuessingGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}