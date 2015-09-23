//
//  HabitHandler.swift
//  Pivit
//
//  Created by Andrew Moeckel on 9/23/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import Foundation
import CoreData

class HabitHandler: CoreDataHandler {
    
    var Habits: [Habit]{
        get{
            return fetchHabits()
        }
    }
    
    //MARK: -Public Functions
    
    //Use to save a new Habit to Core Data
    
    func saveNewHabit(habitName habitname: String, averageCost: Double, picture: UIImage){
        let image = UIImagePNGRepresentation(picture)!
        let id = NSUUID().UUIDString
        
        let keys = ["id", "count", "name", "icon", "averageCost"] as [NSCopying]
        let values = [id, 0, habitname, image, averageCost] as [AnyObject]
        
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        
        saveNewObjectForEntity(entity: .Habit, attributesDictionary: attributesDictionary)
        
    }
    
    //Returns array of Habits from CoreData
    func fetchHabits() -> [Habit] {
        var Habits = [Habit]()
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Habit")
        request.returnsObjectsAsFaults = false
        do {
            Habits = try context.executeFetchRequest(request) as! [Habit]
        } catch {
            print ("error")
        }
        return Habits
    }
    
    

}

