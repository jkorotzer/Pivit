//
//  Habit.swift
//  Pivit
//
//  Created by Jared on 9/16/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit
import CoreData

@objc (Habit)
class Habit: NSManagedObject {
    @NSManaged var averageCost: Double
    @NSManaged var icon: NSData
    @NSManaged var name: String
    @NSManaged var count: Int
    @NSManaged var id: String
}
