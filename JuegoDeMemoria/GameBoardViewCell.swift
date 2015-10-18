//
//  GameBoardCell.swift
//  JuegoDeMemoria
//
//  Created by Rafael Gil Pastor on 17/10/15.
//  Copyright © 2015 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

class GameBoardViewCell:UICollectionViewCell {

    @IBOutlet weak var valueLabel: UILabel!

    var value: String = "?"
    
    private var state: GameBoardCellState
    private var size: GameBoardSize

    override init(frame: CGRect) {
        state = .HiddenCell
        size = .x2
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        size = .x2
        state = .HiddenCell
        super.init(coder: aDecoder)
    }
    
    private func updateState()
    {
        switch state
        {
        case .HiddenCell:
            valueLabel.text = "?"
            valueLabel.backgroundColor = UIColor.lightGrayColor()
            valueLabel.textColor = UIColor.darkGrayColor()
        case .CandidateCell:
            valueLabel.text = self.value
            valueLabel.backgroundColor = UIColor.yellowColor()
            valueLabel.textColor = UIColor.darkGrayColor()
        case .FoundCell:
            valueLabel.text = self.value
            valueLabel.backgroundColor = UIColor.greenColor()
            valueLabel.textColor = UIColor.darkGrayColor()
        }
        
    }

    func setSize(newSize: GameBoardSize)
    {
        size = newSize
        switch size
        {
            case .x2:
                let f:UIFont = self.valueLabel.font.fontWithSize(120.0)
                self.valueLabel.font = f
            case .x4:
                let f:UIFont = self.valueLabel.font.fontWithSize(60.0)
                self.valueLabel.font = f
            case .x6:
                let f:UIFont = self.valueLabel.font.fontWithSize(24.0)
                self.valueLabel.font = f
        }
    }
    func setState(newState:GameBoardCellState)
    {
        state = newState
        self.updateState()
    }
    func getState() -> GameBoardCellState
    {
        return state
    }

}