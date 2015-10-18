//
//  ViewController.swift
//  JuegoDeMemoria
//
//  Created by Rafael Gil Pastor on 16/10/15.
//  Copyright © 2015 Rafael Gil. All rights reserved.
//

import UIKit

//tipo para los tipos de puntutaciones
enum GameScoreType: UInt
{
    case noScore = 0;
    case scoreNormal = 1
    case combo2 = 2
    case combo3 = 3
    case combo4 = 4
    case combo5 = 5
    
    static func score(repetitions: UInt) -> GameScoreType {
        switch repetitions
        {
        case 1: return .scoreNormal
        case 2: return .combo2
        case 3: return .combo3
        case 4: return .combo4
        case let r where r >= 5: return .combo5
        default: return .noScore
        }
    }
}

class GameBoardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var gameBoardCollectionView: UICollectionView!
    
    @IBOutlet weak var gameOptions: UISegmentedControl!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var subMessageLabel: UILabel!
    
    //El tablero del juego. Inicialmente se establece con un tamaño de 2x2
    private var gameBoard: GameBoard = GameBoard(withSize:.x2)
    
    //tupla que guarda el índice del primer y segundo candidato
    private var candidatesIndexes: (Int, Int) = (-1, -1)
    
    //Puntuación
    private var score: UInt = 0
    
    //éxitos continuos
    private var successRepetitions: UInt = 0
    
    //éxitos
    private var success: UInt = 0
    
    //fallos
    private var fails: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //establecemos esta clase como delegado de los protocolos a implementar de la viewcollection
        self.gameBoardCollectionView.delegate = self
        self.gameBoardCollectionView.dataSource = self
        
        //actualizamos mensajes y puntuación
        self.updateScoreAndMessage()
        
        //reiniciamos el tablero con el tamaño por defecto
        self.resetGame(withSize: .x2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Int(self.gameBoard.numCells)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameBoardViewCell", forIndexPath: indexPath) as! GameBoardViewCell
        
        cell.value = self.gameBoard[indexPath.row].value
        cell.setState(self.gameBoard[indexPath.row].state)
        cell.setSize(self.gameBoard.size)
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //tratamos la selección de la celda
        self.manageCellSelecion(withIndexPath: indexPath)
        //actualizamos el tablero en la UI
        self.gameBoardCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //establecemos el tamaño de las celdas para que se ajusten al tamaño de la collectionView
        return CGSizeMake(CGRectGetWidth(self.gameBoardCollectionView.bounds)/CGFloat(self.gameBoard.size.rawValue), CGRectGetWidth(self.gameBoardCollectionView.bounds)/CGFloat(self.gameBoard.size.rawValue))
    }
    
    @IBAction func resetGamePressed(sender: AnyObject) {
        
        //reiniciamos el juego con el tamaño del tablero actualmente seleccionado
        switch self.gameOptions.selectedSegmentIndex
        {
        case 0:
            self.resetGame(withSize: .x2)
        case 1:
            self.resetGame(withSize: .x4)
        case 2:
            self.resetGame(withSize: .x6)
        default:
            self.resetGame(withSize: .x2)
        }
    }
    
    //tratar la selección de la celda
    private func manageCellSelecion(withIndexPath indexPath:NSIndexPath)
    {
        //comprobamos si el usuario está eligiendo el primer o segundo candidato
        if self.candidatesIndexes.0 > -1
        {
            //está eligiendo el segundo candidato
            
            //guardamos el índice del segundo candidato
            self.candidatesIndexes.1 = indexPath.row
            
            //ahora comprobamos si la celda seleccionada es una nueva celda candidata
            if self.gameBoard[indexPath.row].state == GameBoardCellState.HiddenCell
            {
                self.gameBoard[indexPath.row].state = GameBoardCellState.CandidateCell
                //comprobamos si el valor de la celda es igual al del primer candidato
                if self.gameBoard[indexPath.row].value == self.gameBoard[self.candidatesIndexes.0].value
                {
                    //ha acertado
                    
                    //aumentamos el contador de éxitos y repeticiones
                    success++
                    successRepetitions++
                    
                    //actualizamos puntuación
                    score += GameScoreType.score(successRepetitions).rawValue
                    
                    //actualizamos estado celdas candidatas
                    self.gameBoard[candidatesIndexes.0].state = GameBoardCellState.FoundCell
                    self.gameBoard[indexPath.row].state = GameBoardCellState.FoundCell

                    //reiniciamos índices de candidatos
                    self.candidatesIndexes = (-1, -1)

                    //actualizamos mensaje y puntuación en la UI
                    self.updateScoreAndMessage()
                    
                    //comprobamos si hemos llegado al final del juego
                    if success == self.gameBoard.numCells/2
                    {
                        //fin del juego
                        
                        //comprobamos si hemos hecho una jugada impecable
                        if self.fails == 0
                        {
                            self.subMessageLabel.text = "¡¡¡Éxito perfecto!!!"
                        }
                        else {
                            self.subMessageLabel.text = "Enhorabuena, has completado el tablero"
                        }
                        //deshabilitamos el tablero
                        self.gameBoardCollectionView.userInteractionEnabled = false
                    }
                }
                else {
                    //ha fallado

                    //actualizamos contador de fallos
                    fails++
                    //reiniciamos contador de éxitos continuos
                    self.successRepetitions = 0
                    //reiniciamos los índices de los candidatos
                    self.resetCandidates()
                    //actualizamos mensaje y puntuación en la UI
                    self.updateScoreAndMessage()
                    
                }
            }
            else {
                //ha fallado
                
                //actualizamos contador de fallos
                fails++
                //reiniciamos contador de éxitos continuos
                self.successRepetitions = 0
                //reiniciamos los índices de los candidatos
                self.resetCandidates()
                //actualizamos mensaje y puntuación en la UI
                self.updateScoreAndMessage()
                
            }
        }
        else {
            //está eligiendo el primer candidato
            
            //actualizamos el estado de la celda
            self.gameBoard[indexPath.row].state = GameBoardCellState.CandidateCell
            //guardamos el índice del primer candidato
            self.candidatesIndexes.0 = indexPath.row
        }
    }
    
    //actualizar contador y mensajes en la UI
    func updateScoreAndMessage()
    {
        self.scoreLabel.text = String(self.score)
        
        self.messageLabel.text = ""
        self.subMessageLabel.text = ""
        
        if (success == 0 && fails == 0)
        {
            self.subMessageLabel.text = "Empieza cuando quieras"
        }
        else {
            switch successRepetitions
            {
            case GameScoreType.scoreNormal.rawValue:
                self.subMessageLabel.text = "¡Muy bien, sigue así!"
            case GameScoreType.combo2.rawValue:
                self.messageLabel.text = "2 aciertos - COMBO +2"
            case GameScoreType.combo3.rawValue:
                self.messageLabel.text = "3 aciertos - COMBO +3"
            case GameScoreType.combo4.rawValue:
                self.messageLabel.text = "4 aciertos - COMBO +4"
            case let repetitions where repetitions >= GameScoreType.combo5.rawValue:
                self.messageLabel.text = "5 aciertos - COMBO +5"
            default:
                self.subMessageLabel.text = "Ooops, has fallado. Venga, inténtalo de nuevo."
            }
        }
    }
    
    //reiniciar estado e índice de los candidatos
    private func resetCandidates()
    {
        self.gameBoard[self.candidatesIndexes.0].state = GameBoardCellState.HiddenCell
        self.gameBoard[self.candidatesIndexes.1].state = GameBoardCellState.HiddenCell
        self.candidatesIndexes = (-1, -1)
    }
    
    //reinicar juego y tablero
    private func resetGame(withSize size:GameBoardSize)
    {
        
        //comprobamos si nos sirve el tablero que ya tenemos o creamos uno nuevo
        if (self.gameBoard.size != size)
        {
            //creamos un nuevo tablero con el tamaño pedido
            self.gameBoard = GameBoard(withSize: size)
        }
        
        //generamos los valores del tablero
        self.gameBoard.initValues()
        
        //reiniciamos índices de candidatos
        self.candidatesIndexes = (-1, -1)
        
        //reiniciamos contadores
        self.score = 0
        self.successRepetitions = 0
        self.fails = 0
        self.success = 0
        
        //actualizamos mensajes y puntuación
        self.updateScoreAndMessage()
        
        //actualizamos el collectionView del tablero
        self.gameBoardCollectionView.reloadData()

        //habilitamos el tablero
        self.gameBoardCollectionView.userInteractionEnabled = true
    }
    
}

