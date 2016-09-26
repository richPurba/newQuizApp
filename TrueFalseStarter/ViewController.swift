//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let trivia = DataTrivia().trivia
    
    let questionsPerRound = DataTrivia().questionsPerRound
    var questionsAsked = DataTrivia().questionsAsked
    var correctQuestions = DataTrivia().correctQuestions
    var indexOfSelectedQuestion: Int = DataTrivia().indexOfSelectedQuestion
    
    var gameSound: SystemSoundID = DataTrivia().gameSound
    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    // there are two @IB for the 4 buttons: Outlet and ACtion
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayingTheQuestions()// displaying randomly the questions, either true-false, or 4 options
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayingTheQuestions(){
        let pickingRandomGuess = 1
        // i do think that 2 is not a magic number
        if(pickingRandomGuess == 0){
            displayQuestionTrueFalse()
        } else{
            displayQuestionsWithOptions()
        }
    }
    
    func displayQuestionTrueFalse() {//renaming the question for true false
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        let checkThis = questionDictionary["Question"]
        questionField.text = checkThis
        playAgainButton.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        trueButton.hidden = true
        falseButton.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestionTrueFalse()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        trueButton.hidden = false
        falseButton.hidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////This Area is for the Controller of 4 Options view///////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Creating  Outlet for Sample Question, Option1, Option2, Option3, Option4, Play Again
    
    @IBOutlet weak var questionFieldFourOptions: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    let dataFourOptions = DataFourOptions().trivia
    
    func displayQuestionsWithOptions(){
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(dataFourOptions.count)
        let questionDictionary = dataFourOptions[indexOfSelectedQuestion]
        
        //use optional binding with Guard here
        
        guard
        let questionLiteral = questionDictionary["Question"],
        let option1Literal = questionDictionary["Option1"],
        let option2Literal = questionDictionary["Option2"],
        let option3Literal = questionDictionary["Option3"],
        let option4Literal = questionDictionary["Option4"]
        else {return print("not a value")}// no idea what this means
        
        questionFieldFourOptions.text = questionLiteral
        option1.setTitle(option1Literal, forState: UIControlState.Normal)
        option2.setTitle(option2Literal, forState: .Normal)
        option3.setTitle(option3Literal, forState: .Normal)
        option4.setTitle(option4Literal, forState: .Normal)

        
        playAgainButton.hidden = true
    }

    //function for the Action Button
    
 
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

