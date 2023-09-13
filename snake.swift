import SwiftUI

struct ContentView: View {
    @State private var snake: [GridPosition] = [GridPosition(x: 10, y: 10)]
    @State private var food = GridPosition(x: 15, y: 15)
    @State private var direction: Direction = .right
    @State private var isGameOver = false
    @State private var gameTimer: Timer?
    @State private var gameState: GameState = .playing
    
    let gridSize = 20
    
    struct GridPosition: Hashable {
        var x: Int
        var y: Int
    }
    
    enum Direction {
        case up, down, left, right
    }
    
    enum GameState {
        case playing, gameOver
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ForEach(snake, id: \.self) { segment in
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: CGFloat(gridSize), height: CGFloat(gridSize))
                        .position(gridToPoint(segment))
                }
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: CGFloat(gridSize), height: CGFloat(gridSize))
                    .position(gridToPoint(food))
                
                if gameState == .gameOver {
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Button(action: {
                            restartGame()
                        }) {
                            Text("Jogar Novamente")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        let dx = gesture.translation.width
                        let dy = gesture.translation.height
                        
                        if abs(dx) > abs(dy) {
                            if dx > 0 {
                                direction = .right
                            } else {
                                direction = .left
                            }
                        } else {
                            if dy > 0 {
                                direction = .down
                            } else {
                                direction = .up
                            }
                        }
                    }
            )
            .onAppear {
                gameTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                    if !isGameOver {
                        moveSnake()
                        checkCollision(with: geometry.size)
                    }
                }
            }
        }
    }
    
    func gridToPoint(_ position: GridPosition) -> CGPoint {
        let x = CGFloat(position.x * gridSize + gridSize / 2)
        let y = CGFloat(position.y * gridSize + gridSize / 2)
        return CGPoint(x: x, y: y)
    }
    
    func moveSnake() {
        var newHead = snake.first!
        
        switch direction {
        case .up:
            newHead.y -= 1
        case .down:
            newHead.y += 1
        case .left:
            newHead.x -= 1
        case .right:
            newHead.x += 1
        }
        
        snake.insert(newHead, at: 0)
        
        if newHead == food {
            // Generate new food
            let maxX = Int(UIScreen.main.bounds.size.width) / gridSize
            let maxY = Int(UIScreen.main.bounds.size.height) / gridSize
            
            food = GridPosition(
                x: Int.random(in: 0..<maxX),
                y: Int.random(in: 0..<maxY)
            )
        } else {
            snake.removeLast()
        }
    }
    
    func checkCollision(with screenSize: CGSize) {
        let head = snake.first!
        let maxX = Int(screenSize.width) / gridSize
        let maxY = Int(screenSize.height) / gridSize
        
        if head.x < 0 || head.x >= maxX ||
            head.y < 0 || head.y >= maxY ||
            snake.dropFirst().contains(head) {
            isGameOver = true
            gameState = .gameOver
            gameTimer?.invalidate()
        }
    }
    
    func restartGame() {
        snake = [GridPosition(x: 10, y: 10)]
        food = GridPosition(x: 15, y: 15)
        direction = .right
        isGameOver = false
        gameState = .playing
        gameTimer?.invalidate()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            if gameState == .playing {
                moveSnake()
                checkCollision(with: UIScreen.main.bounds.size)
            }
        }
    }
}

struct SnakeGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}