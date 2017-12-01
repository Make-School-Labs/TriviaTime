//
//  TriviaQuestionDatasource.swift
//  TriviaTime
//
//  Created by Eliel A. Gordon on 11/29/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import Foundation
import UIKit

class TriviaQuestionDatasource: NSObject, UITableViewDataSource {
    
    let items: [String]
    
    init(items: [String]) {
        self.items = items
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell")!
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0

        return cell
    }
}
