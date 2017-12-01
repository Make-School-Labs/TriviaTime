//
//  ViewController.swift
//  TriviaTime
//
//  Created by Eliel A. Gordon on 11/29/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit

class TriviaViewController: UIViewController {
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var triviaController: TriviaController?
    let client = APIClient()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetGame()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func resetGame() {
        client.perform(target: Target.getTrivia(amount: "1")) { [weak self] (result) in
            
            DispatchQueue.main.async {
                guard let trivia = result.first else {return}
                
                self?.triviaController = TriviaController(
                    trivia: trivia
                )
                
                self?.question.text = self?.triviaController?.question()
                
                self?.tableView.reloadData()
            }
        }
    }
}

extension TriviaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let triviaController = triviaController else {
            return
        }
        
        let choice = triviaController.choices()[indexPath.row]
        
        let result = triviaController.validateChoice(choice: choice)
        
        let alertController = UIAlertController(
            title: "Result",
            message: result.prettyPrint(),
            preferredStyle: .alert
        )
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
            self.resetGame()
        })
        
        alertController.addAction(ok)
        
        self.present(alertController, animated: true) { () in
            
            triviaController.saveHistory(
                question: triviaController.question(),
                result: result.resolve().result
            )
        }
    }
}


extension TriviaViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return triviaController?.choices().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell")!
        
        cell.textLabel?.text = triviaController?.choices()[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
