//
//  Question.swift
//  HPTrivia
//
//  Created by Weerawut Chaiyasomboon on 8/11/2567 BE.
//

import Foundation

struct Question: Codable{
    let id: Int
    let question: String
    var answers: [String:Bool] = [:]
    let book: Int
    let hint: String
    
    enum QuestionKeys: String, CodingKey{
        case id
        case question
        case answer
        case wrong
        case book
        case hint
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.question = try container.decode(String.self, forKey: .question)
        self.book = try container.decode(Int.self, forKey: .book)
        self.hint = try container.decode(String.self, forKey: .hint)
        
        let correctedAnswer = try container.decode(String.self, forKey: .answer)
        self.answers[correctedAnswer] = true
        
        let wrongAnswers = try container.decode([String].self, forKey: .wrong)
        for wrongAnswer in wrongAnswers{
            self.answers[wrongAnswer] = false
        }
        
        /**
        answers:
         {
             "The Boy Who Lived": true,
             "The Kid Who Survived": false,
             "The Baby Who Beat The Dark Lord": false,
             "The Scrawny Teenager": false
         }
         */
    }
    
}
