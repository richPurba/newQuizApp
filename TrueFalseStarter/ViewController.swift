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
    var selectingTypeOfQuiz: Int = 0
    
    var triviaFourOptions = DataFourOptions().trivia
    var indexOfSelectedQuestion2: Int = 0
    
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
        displayQuestion()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func displayQuestion() {//renaming the question for true false
         selectingTypeOfQuiz = GKRandomSource.sharedRandom().nextIntWithUpperBound(2)
        if selectingTypeOfQuiz == 0{
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
            let questionDictionary = trivia[indexOfSelectedQuestion]
            questionField.text = questionDictionary["Question"]

        } else if selectingTypeOfQuiz == 1 {
            indexOfSelectedQuestion2 = GKRandomSource.sharedRandom().nextIntWithUpperBound(triviaFourOptions.count)
            let fourOptionsQuestionDictonary = triviaFourOptions[indexOfSelectedQuestion2]
            questionFieldFourOptions.text = fourOptionsQuestionDictonary["Question"]
        }
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
            displayQuestion()
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
    
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    ////This Area is for the Controller of 4 Options view ///////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    //Creating  Outlet for Sample Question, Option1, Option2, Option3, Option4, Play Again
    

    
 
    
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
}
