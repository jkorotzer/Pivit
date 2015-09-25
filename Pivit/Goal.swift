//
//  Goal.swift
//  Pivit
//
//  Created by Jared on 9/11/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit
import CoreData

@objc(Goal)
class Goal: NSManagedObject {
    @NSManaged var picture : NSData
    @NSManaged var title: String
    @NSManaged var totalMoneyNeeded: Double
    @NSManaged var progress: Double
    @NSManaged var id: String
    @NSManaged var currentGoal: NSNumber
    @NSManaged var isFinished: Bool
    var isCurrentGoal: Bool {
        get {
            return Bool(currentGoal)
        }
        set {
            currentGoal = NSNumber(bool: newValue)
        }
    }
    @NSManaged var dateStarted: NSDate
}
