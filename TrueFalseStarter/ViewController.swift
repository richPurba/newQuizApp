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
    var wrongSound: SystemSoundID = 0
    var goodSound: SystemSoundID = 0
    var finalResult: SystemSoundID = 0
    var arrayForPostedQuestions: [String] = []
    var triviaCollection: [[String:String]] = []
    var answerCheck = false
    var timerCount = NSTimer()
    var counterTimer = 16// this is actually for 15 seconds rule
    var buttonsOptionClicked = false
    

    @IBOutlet weak var outPutQuestion: UILabel!
    @IBOutlet weak var showAnswer: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var theCorrectAnswer: UILabel!
    @IBOutlet weak var timer: UILabel!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
        displayOptions()
        buttonsDesignDefault()
        
        outputTimer()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
   
    
    func displayQuestion() {//renaming the question for true false
         triviaCollection = DataTrivia().returningTrivia()
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(triviaCollection.count)
        var trivia = triviaCollection[indexOfSelectedQuestion]
        
        //Not to post the same question in the same game
        // i stored the asked questions rather than the index because my Model accomodates two types of Dictionary: TrueFalse and Multiple Choices
        
        if questionsAsked != 0 {
            //restarting the collection to retrive new type of questions
            
            
            // mechanism to recheck the question hasn't been asked before
            var counter = 0
           
            
            while counter < arrayForPostedQuestions.count {
                for storedQuestion in arrayForPostedQuestions{
                    if trivia["Question"] == storedQuestion{
                        counter = 0
                        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(triviaCollection.count)
                        trivia = triviaCollection[indexOfSelectedQuestion]
                        break// break the for loop and start all over again
                    }
                    counter += 1
                }
            }
                    }
        outPutQuestion.text = trivia["Question"]
        arrayForPostedQuestions.append(trivia["Question"]!)
        playAgain.hidden = true
        showAnswer.hidden = true
        theCorrectAnswer.hidden = true
        
    }
    
    func displayOptions(){

        let trivia = triviaCollection[indexOfSelectedQuestion]
        
        if trivia.count == 2{//meaning that this is the anatomy of True False DataModel
        
            option3.hidden = true
            option4.hidden = true
            
            option1.setTitle("True", forState: .Normal)
            option2.setTitle("False", forState: .Normal)
            
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
        option3.hidden = true
        option4.hidden = true
        timer.hidden = true

        
        // Display play again button
        playAgain.hidden = false
        
        outPutQuestion.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    // this need to rework for 4 options
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        
        questionsAsked += 1
        
        showAnswer.hidden = false
        
        
    // changing the color of the unclicked buttons:
        buttonDesignWhenClicked(sender)
        
        let trivia = triviaCollection[indexOfSelectedQuestion]
        
        let correctAnswer = returningTriviaValues(trivia, keyword: "Answer")
        let currentTitleOption1 = option1.currentTitle
        let currentTitleOption2 = option2.currentTitle
        let currentTitleOption3 = option3.currentTitle
        let currentTitleOption4 = option4.currentTitle
        
        let qualifierOption1 = (sender === option1 &&  correctAnswer == currentTitleOption1)
        let qualifierOption2 = (sender === option2 && correctAnswer == currentTitleOption2)
        let qualifierOption3 = (sender === option3 && correctAnswer == currentTitleOption3)
        let qualifierOption4 = (sender === option4 && correctAnswer == currentTitleOption4)
       
        if  qualifierOption1 || qualifierOption2 || qualifierOption3 || qualifierOption4{
            correctQuestions += 1
            
            playGoodSound()
            
            //desing of Correct font
            answerCheck = true
            designShowAnswerButton(with: answerCheck)
        } else {
            
            playWrongSound()
            //design of Wrong font
            answerCheck = false
            designShowAnswerButton(with: answerCheck)
            // showing the answer
            theCorrectAnswer.hidden = false
            let text = "The answer: " + correctAnswer!
            theCorrectAnswer.text = text
        }
        
        loadNextRoundWithDelay(seconds: 2)
        
    }
    
    
    
    func nextRound() {
        
        
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
            playFinalResultSound()
            //removing the values for checking the already posted questions
            arrayForPostedQuestions.removeAll()
            
            showAnswer.hidden = true
        } else {
            // Continue game
            displayQuestion()
            displayOptions()
            counterTimer = 16 // setting back to lightning mode;
            
            //change the buttons color back to normal
            buttonsDesignDefault()
            
            //change the showAnswer button color back to normal
            defaultDesignShowAnswerButton()
        }
    }
    
        // Show the answer buttons
    
    @IBAction func playAgainOption() {
        option1.hidden = false
        option2.hidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
        
        timer.hidden = false
        counterTimer = 16 // setting back to lightning mode;
        
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
        
        //outputTimer()// the label of Timer
        //respondToUnansweredQuestion()
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
        
        let pathToSoundFileWrongSound = NSBundle.mainBundle().pathForResource("wrongAnswer", ofType: "wav")
        let soundURLWrongSound = NSURL(fileURLWithPath: pathToSoundFileWrongSound!)
        AudioServicesCreateSystemSoundID(soundURLWrongSound, &wrongSound)
        
        let pathToSoundFileGoodSound = NSBundle.mainBundle().pathForResource("goodAnswer", ofType: "wav")
        let soundURLGoodSound = NSURL(fileURLWithPath: pathToSoundFileGoodSound!)
        AudioServicesCreateSystemSoundID(soundURLGoodSound, &goodSound)
        
        let pathToSoundFileFinalResult = NSBundle.mainBundle().pathForResource("finalResult", ofType: "wav")
        let soundURLFinalResult = NSURL(fileURLWithPath: pathToSoundFileFinalResult!)
        AudioServicesCreateSystemSoundID(soundURLFinalResult, &finalResult)
        
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    func playWrongSound(){
        AudioServicesPlaySystemSound(wrongSound)
    }
    func playGoodSound(){
        AudioServicesPlaySystemSound(goodSound)
    }
    func playFinalResultSound(){
        AudioServicesPlaySystemSound(finalResult)
    }
    
    // Helper method to pick randomly true-false or multiple choices and return the type of trivia
    
    func returningTriviaValues(withCollection: [String:String],keyword: String) -> String?{
        return withCollection[keyword]
    }
    func returningTriviaCollection(withCollection: [[String:String]])->[String:String]{
     let selectingWhichTrivia = GKRandomSource.sharedRandom().nextIntWithUpperBound(withCollection.count)// 0 for True or False, 1 for Multiple choices
    return withCollection[selectingWhichTrivia]
    }
    
    func buttonsDesignDefault(){
        let cornerRadius: CGFloat = 7.0
        let color = UIColor(red: 0.40, green: 0.80, blue: 1.00, alpha: 1.0)
        option1.layer.cornerRadius = cornerRadius
        option2.layer.cornerRadius = cornerRadius
        option3.layer.cornerRadius = cornerRadius
        option4.layer.cornerRadius = cornerRadius
        playAgain.layer.cornerRadius = cornerRadius
        
        option1.backgroundColor = color
        option2.backgroundColor = color
        option3.backgroundColor = color
        option4.backgroundColor = color
       
        buttonsOptionClicked = false
    }
    
    func buttonDesignWhenClicked(clickedButton: UIButton){
        let color = UIColor(red: 0.16, green: 0.58, blue: 0.75, alpha: 1.0)
        switch clickedButton{
        case option1: option2.backgroundColor = color
            option3.backgroundColor = color
            option4.backgroundColor = color
        case option2: option1.backgroundColor = color
            option3.backgroundColor = color
            option4.backgroundColor = color
        case option3: option1.backgroundColor = color
            option2.backgroundColor = color
            option4.backgroundColor = color
        case option4: option1.backgroundColor = color
            option2.backgroundColor = color
            option3.backgroundColor = color
        default: print("Error")
        }
        buttonsOptionClicked = true
        
    }
    func designShowAnswerButton (with answer: Bool){

        let colorFalse = UIColor(red: 0.8, green: 0.2, blue: 0.0, alpha: 1.0)
        let colorTrue = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        
        
        if answer == true {
            showAnswer.textColor =  colorTrue
            showAnswer.text = "Correct!"
        } else if answer == false{
            showAnswer.textColor = colorFalse
            showAnswer.text = "Sorry, wrong answer!"
        }
    }
    
    func defaultDesignShowAnswerButton(){
        showAnswer.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func outputTimer(){
        if questionsAsked != questionsPerRound{//preventing that at the end of the round, the timer ticks
            timerCount = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true) }
        
    }
    func updateCounter(){
        if counterTimer > 0 {
            counterTimer -= 1
            timer.text = String(counterTimer)
        } else {
            
            theCorrectAnswer.hidden = false
            let didnotAnswer = "You didn't answer anything"
            theCorrectAnswer.text = didnotAnswer
            questionsAsked += 1
            nextRound()

        }
    }
    
    
}
