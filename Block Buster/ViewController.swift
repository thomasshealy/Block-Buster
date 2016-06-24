//
//  ViewController.swift
//  Block Buster
//
//  Created by Thomas Shealy on 5/12/16.
//  Copyright © 2016 Thomas Shealy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let BOARD_SIZE: Int = 10
    var board:Board
    var squareButtons: [[SquareButton]] = []
    var buttonColors: [[Int]] = []
    var called: Int = 0
    var counter: Int = 0
    var clickedWidth: Int = 0
    var clickedHeight: Int = 0
    
    //the board is linked up to register touches here
    @IBOutlet weak var boardView: UIView!
    
    //the new game button is linked up to register touches here
    //counter is reset to zero at the start of a new game
    //students should initialy print "new game" everytime it is pressed for testing purposes
    @IBAction func newGamePressed(){
        //print("new game")
        counter = 0
        self.resetBoard()
    }
    //swift provides this method, all the setup that must be done after loading the view must be done here
    //(initializing the board, and starting the game in our case)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeBoard()
        self.resetBoard()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //another default swift provided method that you'll see everytime you create a new viewcontroller
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //initializes the board, required by swift
    //"Classes and structures must set all of their stored properties to an appropriate initial value
    //by the time an instance of that class or structure is created".
    //needs to include a super.init call.
    required init(coder aDecoder: NSCoder){
        self.board = Board(size: BOARD_SIZE)
        super.init(coder: aDecoder)!
    }
    //sets up the gameboard, loops according to the boardsize adds the squarebuttons to the squarebutton array
    //notice how to add things to a 2d array in swift, you first store (append) a rows worth of info in a 1d array
    //(in our case, the first row will be the equivalent of everything that will go in our 2d array at [0][0-9])
    //then you append that whole array to the  2-d array.  This method also stores "0" for every value in an equally sized integer array.  This will be overwritten later.  The squarebuttons are sized based on the width of the boardview and the board size, I sized the boardviews according to the size of each device.
    //The squarebuttons are added onto the boardview as subviews.  The addTaget bit makes the squarebuttons clickable.
    func initializeBoard(){
        for row in 0 ..< board.size {
            var buttonRow:[SquareButton] = []
            var colorRow: [Int] = []
        for col in 0 ..< board.size {
            let square = board.squares[row][col]
            let squareSize: CGFloat = self.boardView.frame.width / CGFloat(BOARD_SIZE)
            let squareButton = SquareButton(squareModel: square, squareSize: squareSize)
                squareButton.addTarget(self, action: #selector(ViewController.squareButtonPressed(_:)), forControlEvents: .TouchUpInside)
                buttonRow.append(squareButton)
                colorRow.append(0)
                self.boardView.addSubview(squareButton)
            }
            squareButtons.append(buttonRow)
            buttonColors.append(colorRow)
        }
    }
    //this method is called everytime a squarebutton is pressed, if two buttons have been pressed, they will be swapped.
    //this works by checking if the number of clicks (counter) divisable by two.
    func squareButtonPressed(sender: SquareButton){
        counter += 1
        if counter%2 != 0 {
            clickedWidth = sender.square.col
            clickedHeight = sender.square.row
        }
        else {
            swap(clickedHeight, clickedWidth: clickedWidth,
                 height2: sender.square.row, width2: sender.square.col)
            
        }
        //students should initially print the position of each button clicked for testing purposes
        
       // print("Pressed row:\(sender.square.row), col:\(sender.square.col)")
       // sender.setTitle("", forState: .Normal)
        
    }
    //resets the board.  A random integer from 1-9 (each number corresponds to a color) is generated, checks for matches as it moves through the squares on the board.  Because the squares are assigned numbers from left to right, matches on the first row and the first square of each row don't need to be handled by the randomize  method.  The choose color method is called on each square.
    func resetBoard(){
        
        for height in 0 ..< board.size {
            for width in 0 ..< board.size {
            var randomNumber = Int(arc4random_uniform(9))
                //first square
                if height == 0 && width == 0{
                    randomNumber = randomNumber+0
                }
                //squares on first row
                if height == 0 && width != 0{
                    if randomNumber != getLeft(height, width: width){
                        randomNumber = randomNumber+0
                    }
                    else if randomNumber <= 4{
                        randomNumber = randomNumber+1
                    }
                    else{
                        randomNumber = randomNumber-1
                    }
                }
                //first square on each row
                if height != 0 && width == 0{
                    if randomNumber != getAbove(height, width: width){
                        randomNumber = randomNumber+0
                    }
                    else if randomNumber <= 4{
                        randomNumber = randomNumber+1
                    }
                    else{
                        randomNumber = randomNumber-1
                    }
                }
                //everything else
                if  height != 0 && width != 0{
                    if randomNumber != getLeft(height, width: width) &&
                        randomNumber != getAbove(height, width: width){
                        randomNumber = randomNumber+0
                        
                    }
                    else{
                        var left = getLeft(height, width: width)
                        var above = getAbove(height, width: width)
                        randomNumber = randomize(left, cantBe2: above)
                    }
                }
                
                    chooseColor(height, width: width, randomNumber: randomNumber)
                
                    }
        }
        
    }
    
        //gets the number representing the color of the square to the left of a square
    func getLeft(height: Int, width: Int) -> Int{
        return buttonColors[height][width-1]
    }
    //gets the number representing the color of the square to the right of a square
    func getRight(height: Int, width: Int) -> Int{
        return buttonColors[height][width+1]
    }
    //gets the number representing the color of the square above a square
    func getAbove(height: Int, width: Int) -> Int{
        return buttonColors[height-1][width]
    }
    //gets the number representing the color of the square below a square
    func getBelow(height: Int, width: Int) -> Int{
        return buttonColors[height+1][width]
    }
    //assigns a color to a square based on the random number passed in.  Stores that random number in the buttonColors array.  You can't compare UIColors directly, so having integer representations of them is necessary.
    func chooseColor(height: Int, width: Int, randomNumber: Int){
        if randomNumber == 0 {squareButtons[height][width].backgroundColor = UIColor.brownColor()
            buttonColors[height][width] = 0}
        if randomNumber == 1 {squareButtons[height][width].backgroundColor = UIColor.purpleColor()
            buttonColors[height][width] = 1}
        if randomNumber == 2 {squareButtons[height][width].backgroundColor = UIColor.orangeColor()
            buttonColors[height][width] = 2}
        if randomNumber == 3 {squareButtons[height][width].backgroundColor = UIColor.magentaColor()
            buttonColors[height][width] = 3}
        if randomNumber == 4 {squareButtons[height][width].backgroundColor = UIColor.yellowColor()
            buttonColors[height][width] = 4}
        if randomNumber == 5 {squareButtons[height][width].backgroundColor = UIColor.cyanColor()
            buttonColors[height][width] = 5}
        if randomNumber == 6 {squareButtons[height][width].backgroundColor = UIColor.blueColor()
            buttonColors[height][width] = 6}
        if randomNumber == 7 {squareButtons[height][width].backgroundColor = UIColor.greenColor()
            buttonColors[height][width] = 7}
        if randomNumber == 8 {squareButtons[height][width].backgroundColor = UIColor.redColor()
            buttonColors[height][width] = 8}

        
    }
    //this method is fed in the integer representations of the colors of two squares and returns a new value that does not match either one.
    func randomize(cantBe1: Int, cantBe2: Int) -> Int{
        var number = 0
        for _ in 0 ..< 9 {
            number += 1
            if number != cantBe1 && number != cantBe2{
                break
            }
            
        }
        return number
    }
    //swaps the colors of the two squares that it is given, then calls bustBlocks to remove any matches
    func swap(clickedHeight: Int, clickedWidth: Int, height2: Int, width2: Int){
        var temp: Int = buttonColors[clickedHeight][clickedWidth]
        var temp2: Int = buttonColors[height2][width2]
        
        if temp != 10 && temp2 != 10{
        buttonColors[clickedHeight][clickedWidth] = temp2
        buttonColors[height2][width2] = temp
        changeColor(clickedHeight, width: clickedWidth)
        changeColor(height2, width: width2)
            bustBlocks(clickedHeight, width: clickedWidth)
            bustBlocks(height2, width: width2)
        }
    }
    //same logic used to pick the colors of the square, used here to alter squares that were swapped
    func changeColor(height: Int, width: Int){
        
        if buttonColors[height][width] == 0 {squareButtons[height][width].backgroundColor = UIColor.brownColor()}
        if buttonColors[height][width] == 1 {squareButtons[height][width].backgroundColor = UIColor.purpleColor()}
        if buttonColors[height][width] == 2 {squareButtons[height][width].backgroundColor = UIColor.orangeColor()}
        if buttonColors[height][width] == 3 {squareButtons[height][width].backgroundColor = UIColor.magentaColor()}
        if buttonColors[height][width] == 4 {squareButtons[height][width].backgroundColor = UIColor.yellowColor()}
        if buttonColors[height][width] == 5 {squareButtons[height][width].backgroundColor = UIColor.cyanColor()}
        if buttonColors[height][width] == 6 {squareButtons[height][width].backgroundColor = UIColor.blueColor()}
        if buttonColors[height][width] == 7 {squareButtons[height][width].backgroundColor = UIColor.greenColor()}
        if buttonColors[height][width] == 8 {squareButtons[height][width].backgroundColor = UIColor.redColor()}
        
        
        
    }
    
    //checks for matches around the given location, then "busts" those blocks.  Swift got exception handling in 2.0, so this can be rewritten to take advantage of that if we feel the information won't be lost on the students.
    func bustBlocks(height:Int, width: Int) {
                  //Top left corner
                if height == 0 && width == 0{
                    if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustBelow(height, width: width)
                    }
                    else if buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                    }
                    else if buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height, width: width)
                    }
                }
                //top row non corners
                if height == 0 && width != 0 && width != BOARD_SIZE - 1{
                    //all matches
                    if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustLeft(height, width: width)
                        bustBelow(height, width: width)
                    }
                        //right and below match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustBelow(height, width: width)
                        
                    }
                        //left and right match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                        bustLeft(height, width: width)
                    }
                        //left and below match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustLeft(height, width: width)
                        bustBelow(height, width: width)
                    }
                        //below matches
                    else if buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height, width: width)
                    }
                        //left matches
                    else if buttonColors[height][width] == getLeft(height, width: width){
                        bustLeft(height, width: width)
                        
                    }
                        //right matches
                    else if buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                    }
                
                }
                //top right corner
                else if height == 0 && width == BOARD_SIZE-1{
                    //all match
                    if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustLeft(height, width: width)
                        bustBelow(height, width: width)
                    }
                        //left matches
                    else if buttonColors[height][width] == getLeft(height, width: width){
                        bustLeft(height, width: width)
                    }
                     //below matches
                    else if buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height, width: width)
                    }
                    
                }
                    //bottom left corner
                else if width == 0 && height == BOARD_SIZE-1{
                    if buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustAbove(height, width: width)
                        bustRight(height, width: width)
                    }
                    //right matches
                    else if buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                    }
                        //above matches
                    else if buttonColors[height][width] == getAbove(height, width: width){
                        bustAbove(height, width: width)
                    }
                }
                    // right ends non corners not bottom row or top row
                else if width == BOARD_SIZE-1 && height != 0 && height != BOARD_SIZE-1{
                    if buttonColors[height][width] == getLeft(height, width: width) &&
                    buttonColors[height][width] == getAbove(height, width: width) &&
                    buttonColors[height][width] == getBelow(height, width: width){
                        bustLeft(height, width: width)
                        bustAbove(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //left and below  match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustLeft(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //left and above match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getAbove(height, width: width){
                        bustLeft(height, width: width)
                        bustAbove(height, width: width)
                    }
                   
                    //above and below match 
                    else if buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height, width: width)
                        bustAbove(height, width: width)
                        
                    }
                        //left match
                    else if buttonColors[height][width] == getLeft(height, width: width){
                        bustLeft(height, width: width)
                    }
                    //above match
                    else if buttonColors[height][width] == getAbove(height, width: width){
                        bustAbove(height, width: width)
                    }
                    //below match 
                    else if buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height, width: width)
                    }
                    
                }
                    //left ends
                else if height != 0 && width == 0 && height != BOARD_SIZE-1{
                    if buttonColors[height][width] == getBelow(height, width: width) &&
                    buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustBelow(height, width: width)
                        bustAbove(height, width: width)
                        bustRight(height, width: width)
                    }
                    //above and right match
                    else if buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustAbove(height, width: width)
                        bustRight(height, width: width)
                    }
                    //below and right match
                    else if buttonColors[height][width] == getBelow(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustBelow(height, width: width)
                        bustRight(height, width: width)
                    }
                    //above and below
                    else if buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustAbove(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //right matches
                    else if buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                    }
                    //above matches
                    else if buttonColors[height][width] == getAbove(height, width: width){
                        bustAbove(height, width: width)
                    }
                    //below matches
                    else if buttonColors[height][width] == getBelow(height, width: width){

                    bustBelow(height, width: width)
                    bustBelow(height, width: width)

                    }
                    
                    
                    
                }
                    //bottom right corner
                else if height == BOARD_SIZE-1 && width == BOARD_SIZE-1{
                        if buttonColors[height][width] == getAbove(height, width: width) &&
                            buttonColors[height][width] == getLeft(height, width: width){
                            bustAbove(height, width: width)
                            bustLeft(height, width: width)
                    }
                    //above matches
                    else if buttonColors[height][width] == getAbove(height, width: width){
                            bustAbove(height, width: width)
                    }
                    //left matches
                    else if buttonColors[height][width] == getLeft(height, width: width){
                            bustLeft(height, width: width)
                    }
                }
                //bottom row non corners
                else if height == BOARD_SIZE-1 && width != BOARD_SIZE-1{
                    if buttonColors[height][width] == getAbove(height, width: width) &&
                    buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustAbove(height, width: width)
                        bustLeft(height, width: width)
                        bustRight(height, width: width)
                    }
                    //above and left match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                            buttonColors[height][width] == getAbove(height, width: width){
                        bustAbove(height, width: width)
                        bustLeft(height, width: width)
                        
                    }
                    //above and right match
                    else if buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getRight(height, width: width){
                        bustAbove(height, width: width)
                        bustRight(height, width: width)
                    }
                    //left and right match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getLeft(height, width: width){
                        bustLeft(height, width: width)
                        bustRight(height, width: width)
                    }
                    //left matches
                    else if buttonColors[height][width] == getLeft(height,  width: width){
                        bustLeft(height, width: width)
                    }
                    //right matches
                    else if buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                    }
                    //above matches
                    else if buttonColors[height][width] == getAbove(height, width: width){
                        bustAbove(height, width: width)
                    }
                }
                    //normal cases
                else if height != 0 && height != BOARD_SIZE-1 && width != 0 &&
                width != BOARD_SIZE-1{
                    if buttonColors[height][width] == getRight(height, width: width) &&
                    buttonColors[height][width] == getLeft(height, width: width) &&
                    buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustLeft(height, width: width)
                        bustAbove(height, width: width)
                        bustBelow(height, width: width)
                    }
                        //right, left, above match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                    buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getAbove(height, width: width){
                        bustRight(height, width: width)
                        bustLeft(height, width: width)
                        bustAbove(height, width: width)
                    }
                    //right, left, below match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                    buttonColors[height][width] == getLeft(height, width: width) &&
                    buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustLeft(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //left, above and below match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                    buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustLeft(height, width: width)
                        bustAbove(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //right above and below match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustAbove(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //left and above match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getAbove(height, width: width){
                        bustLeft(height, width: width)
                        bustAbove(height, width: width)
                    }
                    //left and below match
                    else if buttonColors[height][width] == getLeft(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustLeft(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //right and above match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getAbove(height, width: width){
                        bustRight(height, width: width)
                        bustAbove(height, width: width)
                    }
                    //right and below match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustRight(height, width: width)
                        bustBelow(height, width: width)
                    }
                    //above and below match
                    else if buttonColors[height][width] == getAbove(height, width: width) &&
                        buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height, width: width)
                        bustAbove(height, width: width)
                    }
                    //right and left match
                    else if buttonColors[height][width] == getRight(height, width: width) &&
                        buttonColors[height][width] == getLeft(height, width: width){
                        bustRight(height, width: width)
                        bustLeft(height, width: width)
                    }
                    //right match
                    else if buttonColors[height][width] == getRight(height, width: width){
                        bustRight(height, width: width)
                    }
                    //left match
                    else if buttonColors[height][width] == getLeft(height, width: width){
                        bustLeft(height, width: width)
                    }
                    //above match
                    else if buttonColors[height][width] == getAbove(height, width: width){
                        bustAbove(height, width: width)
                    }
                    //below match
                    else if buttonColors[height][width] == getBelow(height, width: width){
                        bustBelow(height,width: width)
                    }
                }
        
    }
    //"busts" (turns white) the block fed in and the block above
    func bustAbove(height: Int, width: Int){
        buttonColors[height][width] = 10
        buttonColors[height-1][width] = 10
        squareButtons[height][width].backgroundColor = UIColor.whiteColor()
        squareButtons[height-1][width].backgroundColor = UIColor.whiteColor()
    }
    //"busts" (turns white) the block fed in and the block below
    func bustBelow(height: Int, width: Int){
        buttonColors[height][width] = 10
        buttonColors[height+1][width] = 10
        squareButtons[height][width].backgroundColor = UIColor.whiteColor()
        squareButtons[height+1][width].backgroundColor = UIColor.whiteColor()
    }
    //"busts" (turns white) the block fed in and the block to the right
    func bustRight(height: Int, width: Int){
        buttonColors[height][width] = 10
        buttonColors[height][width+1] = 10
        squareButtons[height][width].backgroundColor = UIColor.whiteColor()
        squareButtons[height][width+1].backgroundColor = UIColor.whiteColor()
        
    }
    //"busts" (turns white) the block fed in and the block to the left
    func bustLeft(height: Int, width: Int){
        buttonColors[height][width] = 10
        buttonColors[height][width-1] = 10
        squareButtons[height][width].backgroundColor = UIColor.whiteColor()
        squareButtons[height][width-1].backgroundColor = UIColor.whiteColor()
    }
 
}

