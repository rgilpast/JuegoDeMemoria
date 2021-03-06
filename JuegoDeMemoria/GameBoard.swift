//
//  GameBoard.swift
//  JuegoDeMemoria
//
//  Created by Rafael Gil Pastor on 18/10/15.
//  Copyright © 2015 Rafael Gil. All rights reserved.
//

import Foundation

//tipo para indicar el tamaño del tablero
enum GameBoardSize: UInt
{
    case x2 = 2
    case x4 = 4
    case x6 = 6
}

//tipo para indicar el estado de una celda del tablero
enum GameBoardCellState {
    case HiddenCell
    case CandidateCell
    case FoundCell
}

//estructura que representa una celda del tablero
struct GameBoardCell {
    
    
    internal var value: String = ""
    internal var state: GameBoardCellState = GameBoardCellState.HiddenCell
    
    init()
    {
        self.value = ""
        self.state = GameBoardCellState.HiddenCell
        
    }
    
    init(value:String)
    {
        self.value = value
        self.state = GameBoardCellState.HiddenCell
    }
    
}

//clse para manejar el tablero
class GameBoard {
    
    private let rows: UInt, columns: UInt
    private var board: [GameBoardCell]
    var size: GameBoardSize = GameBoardSize.x2
    var numCells: UInt {
        return self.size.rawValue*self.size.rawValue
    }
    
    init(withSize size: GameBoardSize) {
        
        self.size = size
        self.rows = self.size.rawValue
        self.columns = self.size.rawValue
        self.board = Array(count: (Int)(self.rows * self.columns), repeatedValue: GameBoardCell())
        
    }
    
    private func indexIsValidForRow(row: UInt, column: UInt) -> Bool {
        return row >= 0 && row < self.rows && column >= 0 && column < self.columns
    }
    
    private func indexIsValid(index: Int) -> Bool {
        return index >= 0 && index < self.board.count
    }

    subscript(cellIndex: Int) -> GameBoardCell {
        get {
            assert(indexIsValid(cellIndex), "Index out of range")
            return self.board[cellIndex]
        }
        set {
            assert(indexIsValid(cellIndex), "Index out of range")
            self.board[cellIndex] = newValue
        }
    }

    subscript(row: UInt, column: UInt) -> GameBoardCell {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return self.board[(Int)((row * columns) + column)]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            self.board[(Int)((row * columns) + column)] = newValue
        }
    }
    
    //mezclar aleatoriamente las celdas del tablero
    func shuffleValues()
    {
        //desordenamos las celdas aleatoriamente
        for i in 0..<self.numCells - 1 {
            let j = UInt(arc4random_uniform(UInt32(self.numCells-i))) + i
            guard i != j else { continue }
            swap(&self.board[Int(i)], &self.board[Int(j)])
        }
    }
    
    //inicializar el tablero con nuevos valores aleatorios
    func initValues()
    {
        
        // Los valores posibles del tablero
        var candidates = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        //el contador de valores a generar
        var valuesCounter:UInt = self.numCells
        
        //iteramos hasta que hayamos rellenado el tablero con los nuevos valores
        while valuesCounter>0
        {
            //seleccionar aleatoriamente un candidato
            let candidateIndex:Int = Int(arc4random_uniform(UInt32(candidates.count)));
            
            //añadimos el candidato dos veces, pues será una de las parejas que el usuario debe buscar
            self.board[Int(self.numCells-valuesCounter)].value = candidates[candidateIndex]
            self.board[Int(self.numCells-valuesCounter+1)].value = candidates[candidateIndex]
            
            //establecemos el estado inicial de cada celda a Hidden
            self.board[Int(self.numCells-valuesCounter)].state = .HiddenCell
            self.board[Int(self.numCells-valuesCounter+1)].state = .HiddenCell
            
            // eliminamos el candidato elegido para que no se pueda elegir otra vez
            candidates.removeAtIndex(candidateIndex)
            
            //decrementamos el contador de valores a generar
            valuesCounter-=2
        }
        
        //desordenamos los valores, para evitar que los pares estén juntos
        self.shuffleValues()
        
    }
    
}
