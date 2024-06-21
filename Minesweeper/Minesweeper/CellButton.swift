//
//  CellButton.swift
//  Minesweeper
//
//  Created by student on 28.05.2024.
//

import Foundation
import UIKit

enum CellType {
    case empty
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case bomb
}

enum CellCover {
    case none
    case simple
    case flag
}

class CellButton: UIButton {
    var row, col: Int
    var cellType: CellType
    var cellCover: CellCover

    init(row: Int, col: Int, cellType: CellType = CellType.empty, cellCover: CellCover = CellCover.simple) {
        self.row = row
        self.col = col
        self.cellType = cellType
        self.cellCover = cellCover
        
        super.init(frame: .zero)
        
        updateButtonImage()
    }
    
    func setCellCover(cellCover: CellCover) {
        self.cellCover = cellCover
        
        updateButtonImage()
    }
    
    func updateButtonImage() {
        var imgName: String
        switch cellCover {
        case .simple:
            imgName = "simpleCover.png"
        case .none:
            switch cellType {
            case .empty:
                imgName = "empty.png"
            case .one:
                imgName = "one.png"
            case .two:
                imgName = "two.png"
            case .three:
                imgName = "three.png"
            case .four:
                imgName = "four.png"
            case .five:
                imgName = "five.png"
            case .six:
                imgName = "six.png"
            case .seven:
                imgName = "seven.png"
            case .eight:
                imgName = "eight.png"
            case .bomb:
                imgName = "bomb.png"
            }
        case .flag:
            imgName = "flag.png"
        }
        
        setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
