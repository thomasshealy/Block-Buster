//
//  Board.swift
//  Block Buster
//
//  Created by Thomas Shealy on 5/14/16.
//  Copyright © 2016 Thomas Shealy. All rights reserved.
//

import Foundation

class Board{
    
    var size:Int
    var squares: [[Square]]=[]
    //Board object, has a size quantity that determines how many squares are placed on it.
    //To add things to a 2-d array in swift: store one rows worth of things in a 1-d array(so if it was a [10][10] array you'd store everything from [0][0-9] for the first row) and then append that 1-d array to the 2-d array.
    init(size:Int){
        self.size=size
        
        for row in 0 ..< size{
            var squareRow:[Square]=[]
            for col in 0 ..< size{
                let square = Square(row: row,  col: col)
                squareRow.append(square)
            }
            
            
        squares.append(squareRow)
        }
    }

    
    }
    
