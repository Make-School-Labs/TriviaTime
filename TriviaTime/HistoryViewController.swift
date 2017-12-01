//
//  HistoryViewController.swift
//  TriviaTime
//
//  Created by Eliel A. Gordon on 11/29/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let realmManager = RealmManager()
    
    var notificationToken: NotificationToken? = nil
    var history = [AnsweredTrivia]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "History"
        
        self.navigationController?
            .navigationBar
            .setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 55
        
        let realm = try! Realm()
        let results = realm.objects(AnsweredTrivia.self)
        
        // Observe Results Notifications
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case let .initial(collection):
                let collectionResults = Array(collection)
                self?.history = collectionResults
                
                // Results are now populated and can be accessed without blocking the UI
                
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                //                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                //                                     with: .automatic)
                //                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                //                                     with: .automatic)
                //                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                //                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")
        
        let answered = history[indexPath.row]
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        
        cell?.textLabel?.text = answered.question
        let displayResult = answered.result == true ? "correct 👍": "wrong 🙅‍♀️"
        
        cell?.detailTextLabel?.text = "You got the answer \(displayResult)"
        
        return cell!
    }
}

extension HistoryViewController: UITableViewDelegate {
    
}
