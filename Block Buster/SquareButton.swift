//
//  SquareButton.swift
//  Block Buster
//
//  Created by Thomas Shealy on 5/14/16.
//  Copyright © 2016 Thomas Shealy. All rights reserved.
//

import Foundation
import UIKit

class SquareButton : UIButton{
    let squareSize:CGFloat
    var square:Square
    //initializes a square button.  x and y are the offsets of each squarebutton.  
    //CGRectMake creates the square itself, and requires a call to the super.
    init(squareModel:Square, squareSize: CGFloat){
        self.square = squareModel
        self.squareSize = squareSize
        let x = CGFloat(self.square.col) * squareSize
        let y = CGFloat(self.square.row) * squareSize
        let squareFrame = CGRectMake(x, y, squareSize, squareSize)
        super.init(frame: squareFrame)
        
    }
    

    //required by swift, auto generated.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
