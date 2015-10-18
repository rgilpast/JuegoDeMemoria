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
    var state: GameBoardCellState {
        get {
            return self.state
        }
        set {
            switch self.state
            {
            case .HiddenCell:
                valueLabel.text = "?"
                valueLabel.backgroundColor = UIColor.lightGrayColor()
                valueLabel.textColor = UIColor.darkGrayColor()
                break
            case .CandidateCell:
                valueLabel.text = self.value
                valueLabel.backgroundColor = UIColor.yellowColor()
                valueLabel.textColor = UIColor.darkGrayColor()
                break
            case .FoundCell:
                valueLabel.text = self.value
                valueLabel.backgroundColor = UIColor.greenColor()
                valueLabel.textColor = UIColor.darkGrayColor()
                break
            }
        }
    }

}