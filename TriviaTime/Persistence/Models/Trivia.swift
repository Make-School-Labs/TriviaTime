//
//  Trivia.swift
//  TriviaTime
//
//  Created by Eliel A. Gordon on 11/29/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import Foundation
import RealmSwift

class AnsweredTrivia: Object {
    @objc dynamic var question = ""
    @objc dynamic var result = false
}
