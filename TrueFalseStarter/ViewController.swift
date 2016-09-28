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

    
    var selectingTypeOfQuiz = GKRandomSource.sharedRandom().nextIntWithUpperBound(2)
    
  
    let questionsPerRound = DataTrivia().questionsPerRound
    var questionsAsked = DataTrivia().questionsAsked
    var correctQuestions = DataTrivia().correctQuestions
    var indexOfSelectedQuestion: Int = DataTrivia().indexOfSelectedQuestion
    
    var gameSound: SystemSoundID = DataTrivia().gameSound
    
    
// renaming the Outlet to accomodate 4 options
    

    @IBOutlet weak var outPutQuestion: UILabel!
    @IBOutlet weak var showAnswer: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var playAgain: UIButton!
    


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
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(returningTrivia().count)
            let questionDictionary = returningTrivia()[indexOfSelectedQuestion]
            outPutQuestion.text = questionDictionary["Question"]
               playAgain.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        option1.hidden = true
        option2.hidden = true
        
        // Display play again button
        playAgain.hidden = false
        
        outPutQuestion.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    // this need to rework for 4 options
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = returningTrivia()[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === option1 &&  correctAnswer == "True") || (sender === option2 && correctAnswer == "False") {
            correctQuestions += 1
            outPutQuestion.text = "Correct!"
        } else {
            outPutQuestion.text = "Sorry, wrong answer!"
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
    // need to rework for 4 options
        // Show the answer buttons
    
    @IBAction func playAgainOption() {
        option1.hidden = false
        option2.hidden = false
        
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
  
    
    // Helper method to pick randomly true-false or multiple choices and return the type of trivia
    func returningTrivia()-> [[String:String]]{
        var questions = [[String: String]]()
        
        if (selectingTypeOfQuiz == 0) {// True False question
            questions = DataTrivia().trivia
        } else if selectingTypeOfQuiz == 1 { // Multiple Choices
            questions = DataFourOptions().trivia
            
        }
        return questions
    }
}
