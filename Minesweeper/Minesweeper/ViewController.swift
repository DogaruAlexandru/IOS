//
//  ViewController.swift
//  Minesweeper
//
//  Created by student on 28.05.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameBoard: UIView!
    @IBAction func newGameAction(_ sender: Any) {
        newGame()
        gameBoard.isUserInteractionEnabled = true
    }
    
    // MARK: game vars and methods
    
    enum GameState {
        case running
        case lost
        case won
    }
    
    let rowIndexes = [-1, -1, -1, 0, 1, 1, 1, 0]
    let colIndexes = [-1, 0, 1, 1, 1, 0, -1, -1]
    let noRows = 10, noCols = 10, bombCount = 10
    
    var gameState = GameState.running
    var flagsUsed = 0
    
    var buttons = [[CellButton]]()
    
    func makeGrid(rows: Int, cols: Int, root: UIView) {
        
        // make vertical stack view
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.spacing = 1
        
        // repeat for each row
        for row in 0 ..< rows {
            // make the horizontal stack
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .fill
            hStack.distribution = .fillEqually
            hStack.spacing = 1
            
            // make a new row in buttons
            buttons.append([])
            for col in 0 ..< cols {
                // make the cell button
                let button = CellButton(row: row, col: col)

                buttons[row].append(button)
                hStack.addArrangedSubview(button)

                button.addTarget(self, action: #selector(onButtonRelease), for: .touchUpInside)
                button.addTarget(self, action: #selector(onButtonPressRepeat), for: .touchDownRepeat)
            }
            
            vStack.addArrangedSubview(hStack)
        }
        root.addSubview(vStack)
        
        // constraint vStack
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        vStack.topAnchor.constraint(equalTo: root.topAnchor, constant: 1).isActive = true
        vStack.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: -1).isActive = true
        vStack.leftAnchor.constraint(equalTo: root.leftAnchor, constant: 1).isActive = true
        vStack.rightAnchor.constraint(equalTo: root.rightAnchor, constant: -1).isActive = true
    }
    
    func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set)
    }
    
    func newGame() {
        flagsUsed = 0
        
        let bombList = getUniqueRandomNumbers(min: 0, max: noCols * noRows - 1, count: bombCount)
        var countsMatrix = Array(repeating: Array(repeating: 0, count: noCols), count: noRows)
        
        for pos in bombList {
            let row = pos / noCols
            let col = pos % noCols
            
            countsMatrix[row][col] = -1
            
            for auxIndex in 0...8 {
                let auxRow = row + rowIndexes[auxIndex]
                let auxCol = col + colIndexes[auxIndex]
                
                if auxRow > 0 && auxCol > 0 && auxRow < noRows - 1 && auxCol < noCols - 1 && countsMatrix[auxRow][auxCol] != -1 {
                    countsMatrix[auxRow][auxCol] += 1
                }
            }
        }
        
        for row in 0 ..< noRows {
            for col in 0 ..< noCols {
                switch countsMatrix[row][col] {
                case -1:
                    buttons[row][col].cellType = .bomb
                case 0:
                    buttons[row][col].cellType = .empty
                case 1:
                    buttons[row][col].cellType = .one
                case 2:
                    buttons[row][col].cellType = .two
                case 3:
                    buttons[row][col].cellType = .three
                case 4:
                    buttons[row][col].cellType = .four
                case 5:
                    buttons[row][col].cellType = .five
                case 6:
                    buttons[row][col].cellType = .six
                case 7:
                    buttons[row][col].cellType = .seven
                case 8:
                    buttons[row][col].cellType = .eight
                default:
                    break
                }
            }
        }
    }
    
    @objc func onButtonRelease(button: CellButton) {
        revealCell(button: button)
        gameOverHandling()
    }
    
    @objc func onButtonPressRepeat(button: CellButton) {
        button.setCellCover(cellCover: .flag)
    }
    
    func revealCell(button: CellButton) {
        button.setCellCover(cellCover: .none)
        
        if button.cellType == .bomb {
            gameState = .lost
            return
        } else if button.cellType != .empty {
            return
        }
        
        var row, col : Int
        var queue = [(Int, Int)]()
        queue.append((button.row, button.col))
        
        while !queue.isEmpty {
            (row, col) = queue.removeFirst()
            
            for auxIndex in 0...8 {
                let auxRow = row + rowIndexes[auxIndex]
                let auxCol = col + colIndexes[auxIndex]
                
                let auxButton = buttons[auxRow][auxCol]
                
                if auxRow > 0 && auxCol > 0 && auxRow < noRows - 1 && auxCol < noCols - 1 && auxButton.cellCover == .simple {
                    switch auxButton.cellType {
                    case .bomb:
                        break
                    case .empty:
                        queue.append((auxRow, auxCol))
                    default:
                        auxButton.setCellCover(cellCover: .none)
                    }
                }
            }
        }
        
        // TODO: Reavel and set gameState if ended
    }
    
    func gameOverHandling() {
        switch gameState {
        case GameState.running:
            if areBombsFound() {
                gameBoard.isUserInteractionEnabled = true
                print("Game Won!")
            }
        case GameState.lost:
            gameBoard.isUserInteractionEnabled = true
            print("Game Lost!")
        case GameState.won:
            break
        }
    }
    
    func areBombsFound() -> Bool {
        var countNoneCover = 0
        for row in 0 ..< noRows {
            for col in 0 ..< noCols {
                if buttons[row][col].cellCover == .simple{
                    countNoneCover += 1
                }
            }
        }
        
        return noRows * noCols - bombCount == countNoneCover
    }
    
    func flagCell(button: CellButton) {
        button.setCellCover(cellCover: CellCover.flag)
        flagsUsed += 1
        print("Used \(flagsUsed) out of \(bombCount) bombs")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeGrid(rows: noRows, cols: noCols, root: gameBoard)
        newGame()
    }
}

