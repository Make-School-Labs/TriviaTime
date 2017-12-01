//
//  TriviaController.swift
//  TriviaTime
//
//  Created by Eliel A. Gordon on 11/29/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import Foundation

enum TriviaChoiceResult {
    case correct(answer: String)
    case wrong(answer: String)
    
    func resolve() -> (answer: String, result: Bool) {
        switch self {
        case let .correct(answer):
            return (answer, true)
        case let .wrong(answer):
            return (answer, false)
        }
    }
    
    func prettyPrint() -> String {
        switch self {
        case .correct:
            return "You got the question correct"
        case let .wrong(answer):
            return "You got the question wrong, the correct answer was \(answer.removingPercentEncoding!)"
        }
    }
}

struct TriviaController {
    let req = APIClient()
    let realmManager = RealmManager()
    private let trivia: JSONTrivia
    
    init(trivia: JSONTrivia) {
        self.trivia = trivia
    }
    
    func refresh(completion: @escaping (_ question: String, _ answer: String, _ choices: [String]) -> Void) {
        
        req.perform(target: Target.getTrivia(amount: "1")) { (result) in
            
            guard let result = result.first else {return}

            completion(result.question, result.answer, result.incorrectAnswers)
        }
    }
    
    func validateChoice(choice: String) -> TriviaChoiceResult {
        guard choice == trivia.answer else {
            return .wrong(answer: trivia.answer)
        }
        
        return .correct(answer: trivia.answer)
    }
    
    func choices() -> [String] {
        let choices = trivia.incorrectAnswers.map{$0.removingPercentEncoding!} + [trivia.answer.removingPercentEncoding!]
        return choices
    }
    
    func question() -> String {
        return trivia.question.removingPercentEncoding!
    }
    
    func saveHistory(question: String, result: Bool) {
        let answered = AnsweredTrivia()
        answered.question = question
        answered.result = result
        
        try! realmManager.realm.write {
            realmManager.realm.add(answered)
        }
    }
    
}
