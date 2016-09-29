//
//  DataFile.swift
//  TrueFalseStarter
//
//  Created by Richard Purba on 26/09/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

struct DataTrivia{
    

       
    let triviaTrueFalse: [[String : String]] = [//stored properties
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    

    //
    ///////////////////////////
    ///////////////////////////////////
    /////Multiple Choices
    ///////////////////////////////////
    //////////////////////////
    let triviaMultipleChoices:[[String: String]] = [
        ["Question": "This was the only US President to serve more than two consecutive terms.",
            "Option1":"George Washington",
            "Option2":"Franklin D. Roosevelt",
            "Option3":"Woodrow Wilson",
            "Option4":"Andrew Jackson",
            "Answer": "Franklin D. Roosevelt"],
        ["Question":"Which of the following countries has the most residents?",
            "Option1":"Nigeria",
            "Option2":"Russia",
            "Option3":"Iran",
            "Option4":"Vietnam",
            "Answer":"Nigeria",],
        ["Question":"In what year was the United Nations founded?",
            "Option1":"1918",
            "Option2":"1919",
            "Option3":"1945",
            "Option4":"1954",
            "Answer":"1945",],
        ["Question":"The Titanic departed from the United Kingdom, where was it supposed to arrive?",
            "Option1":"Paris",
            "Option2":"Washington D.C.",
            "Option3":"New York City",
            "Option4":"Boston",
            "Answer":"New York City",],
        ["Question":"Which nation produces the most oil?",
            "Option1":"Iran",
            "Option2":"Iraq",
            "Option3":"Brazil",
            "Option4":"Canada",
            "Answer":"Canada",],
        ["Question":"Which country has most recently won consecutive World Cups in Soccer?",
            "Option1":"Italy",
            "Option2":"Brazil",
            "Option3":"Argetina",
            "Option4":"Spain",
            "Answer":"Brazil",],
        ["Question":"Which of the following rivers is longest?",
            "Option1":"Yangtze",
            "Option2":"Mississippi",
            "Option3":"Congo",
            "Option4":"MekongMekong",
            "Answer":"Mississippi",],
        ["Question":"Which city is the oldest?",
            "Option1":"Mexico City",
            "Option2":"Cape Town",
            "Option3":"San Juan",
            "Option4":"Sydney",
            "Answer":"Mexico City",],
        ["Question":"Which country was the first to allow women to vote in national elections?",
            "Option1":"Poland",
            "Option2":"United States",
            "Option3":"Sweden",
            "Option4":"Senegal",
            "Answer":"Poland",],
        ["Question":"Which of these countries won the most medals in the 2012 Summer Games?",
            "Option1":"France",
            "Option2":"Germany",
            "Option3":"Japan",
            "Option4":"Great Britain",
            "Answer":"Great Britain",]]
    
    
    func returningTrivia()-> [[String:String]]{
        
        let selectingTypeOfQuiz = GKRandomSource.sharedRandom().nextIntWithUpperBound(2)// 0 for True or False, 1 for Multiple choices

        var triviaCollections = [[String: String]]()
        
        if (selectingTypeOfQuiz == 0) {// True False question
            triviaCollections = triviaTrueFalse
        } else if selectingTypeOfQuiz == 1 { // Multiple Choices
            triviaCollections = triviaMultipleChoices
            
        }
        
        
        
        return triviaCollections
    }
    

}



