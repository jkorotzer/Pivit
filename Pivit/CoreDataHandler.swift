//
//  CoreDataHandler.swift
//  Pivit
//
//  Created by Jared on 9/17/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import Foundation
import CoreData

enum EntityToEdit {
    case Goal
    case Habit
}

//This class is meant to be subclassed! Do not instantiate. Use GoalHandler or HabitHandler instead.
class CoreDataHandler {
    
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
    
    //Edits existing entry for a specified entity
    func editExistingObjectForEntity(entity entity: EntityToEdit, id: String, attributesDictionary: NSDictionary) {
        
        var entityToEditFetchResults: [AnyObject]?
        var entityName: String?
        
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        switch entity {
        case .Goal: entityName = "Goal"
        case .Habit: entityName = "Habit"
        }
        let request = NSFetchRequest(entityName: entityName!)
        request.predicate = NSPredicate(format: "id = %@", id)
        request.returnsObjectsAsFaults = false
        do {
            switch entity {
            case .Goal: entityToEditFetchResults = try context.executeFetchRequest(request) as? [Goal]
            case .Habit: entityToEditFetchResults = try context.executeFetchRequest(request) as? [Habit]
            }
        } catch {
            print ("error")
        }
        
        if entityToEditFetchResults!.count != 0 {
            let entity = entityToEditFetchResults![0]
            let keysAndValues = attributesDictionary as! [String : AnyObject]
            entity.setValuesForKeysWithDictionary(keysAndValues)
        }
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("error")
        }
        
    }
    
    //Saves new object to Core Data
    func saveNewObjectForEntity(entity entity: EntityToEdit, attributesDictionary: NSDictionary) {
        
        var objectToSave: AnyObject?
        
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        switch entity {
        case .Goal: objectToSave = NSEntityDescription.insertNewObjectForEntityForName("Goal", inManagedObjectContext: context) as! Goal
        case .Habit: objectToSave = NSEntityDescription.insertNewObjectForEntityForName("Habit", inManagedObjectContext: context) as! Habit
        }
        
        objectToSave!.setValuesForKeysWithDictionary(attributesDictionary as! [String : AnyObject])
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    
}
