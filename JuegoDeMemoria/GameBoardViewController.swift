//
//  ViewController.swift
//  JuegoDeMemoria
//
//  Created by Rafael Gil Pastor on 16/10/15.
//  Copyright © 2015 Rafael Gil. All rights reserved.
//

import UIKit


class GameBoardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //El tablero del juego. Inicialmente se establece con un tamaño de 2x2
    private var gameBoard: GameBoard = GameBoard(size: .x2)
    
    //tupla que guarda el índice del primer y segundo candidato
    private var indicesCandidatos: (Int, Int) = (-1, -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //inicializamos los valores del tablero
        self.gameBoard.initValues();
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
        return self.gameBoard.numCells
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameBoardViewCell", forIndexPath: indexPath) as! GameBoardViewCell
        
        cell.value = gameBoard[indexPath.row].value
        cell.state = gameBoard[indexPath.row].state
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        //let theCell = cell as! GameBoardViewCell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //comprobamos si el usuario está eligiendo el primer o segundo candidato
        if (self.indicesCandidatos.0 > -1)
        {
            //está eligiendo el segundo candidato
            
            //guardamos el índice del segundo candidato
            self.indicesCandidatos.1 = indexPath.row
            
            //ahora comprabamos si la celda seleccionada es una nueva celda candidata
            if self.gameBoard[indexPath.row].state == GameBoardCellState.HiddenCell
            {
                self.gameBoard[indexPath.row].state = GameBoardCellState.CandidateCell
                //comprobamos si el valor de la celda es igual al del primer candidato
                if self.gameBoard[indexPath.row].value == self.gameBoard[self.indicesCandidatos.0].value
                {
                    //ha acertado
                }
                else {
                    //ha fallado
                }
            }
            else {
                //ha fallado
            }
        }
        else {
            //está eligiendo el primer candidato
            
            //actualizamos el estado de la celda
            self.gameBoard[indexPath.row].state = GameBoardCellState.CandidateCell
            //guardamos el índice del primer candidato
            self.indicesCandidatos.0 = indexPath.row
        }
    }
    
    //reiniciar estado e índice de los candidatos
    private func reiniciarCandidatos()
    {
        self.gameBoard[self.indicesCandidatos.0].state = GameBoardCellState.HiddenCell
        self.gameBoard[self.indicesCandidatos.1].state = GameBoardCellState.HiddenCell
        self.indicesCandidatos = (-1, -1)
    }
}

