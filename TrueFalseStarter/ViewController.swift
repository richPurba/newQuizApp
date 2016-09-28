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

            
    let questionsPerRound: Int = 4
    var questionsAsked: Int = 0
    var correctQuestions: Int = 0
    var indexOfSelectedQuestion: Int = 0
    var gameSound: SystemSoundID = 0

    var triviaCollection = DataTrivia().returningTrivia()
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
        displayOptions()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   
    
    func displayQuestion() {//renaming the question for true false
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(triviaCollection.count)
        let trivia = triviaCollection[indexOfSelectedQuestion]
        outPutQuestion.text = trivia["Question"]
        playAgain.hidden = true
    }
    
    func displayOptions(){
        let trivia = triviaCollection[indexOfSelectedQuestion]
        
        if trivia.count == 2{//meaning that this is the anatomy of True False DataModel
            option1.setTitle("True", forState: .Normal)
            option2.setTitle("False", forState: .Normal)
            option3.hidden = true
            option4.hidden = true
        } else {
            option3.hidden = false
            option4.hidden = false
            
            option1.setTitle(returningTriviaValues(trivia, keyword: "Option1"), forState: .Normal)
            option2.setTitle(returningTriviaValues(trivia, keyword: "Option2"), forState: .Normal)
            option3.setTitle(returningTriviaValues(trivia, keyword: "Option3"), forState: .Normal)
            option4.setTitle(returningTriviaValues(trivia, keyword: "Option4"), forState: .Normal)
        }
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
        
        let trivia = triviaCollection[indexOfSelectedQuestion]
        
        let correctAnswer = returningTriviaValues(trivia, keyword: "Answer")
        
        if (sender === option1 &&  correctAnswer == "True") || (sender === option2 && correctAnswer == "False") {
            correctQuestions += 1
            outPutQuestion.text = "Correct!"
        } else {
            outPutQuestion.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
        
        //restarting the collection to retrive new type of questions
         triviaCollection = DataTrivia().returningTrivia()
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
    
    func returningTriviaValues(withCollection: [String:String],keyword: String) -> String?{
        return withCollection[keyword]
    }
    func returningTriviaCollection(withCollection: [[String:String]])->[String:String]{
     let selectingWhichTrivia = GKRandomSource.sharedRandom().nextIntWithUpperBound(withCollection.count)// 0 for True or False, 1 for Multiple choices
    return withCollection[selectingWhichTrivia]
    }
    
   }
