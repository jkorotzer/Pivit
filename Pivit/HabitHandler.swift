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
    
    //MARK: - Properties
    
    var habits: [Habit] {
        get {
            return fetchHabits()
        }
    }
    
    //MARK: - Public Functions
    
    //Use to save a new Habit to Core Data
    
    func saveNewHabit(habitName habitname: String, averageCost: Double, picture: UIImage, isDefault: Bool) {
        
        let image = UIImagePNGRepresentation(picture)!
        let id = NSUUID().UUIDString

        let keys = ["id", "count", "name", "icon", "averageCost", "isDefault"] as [NSCopying]
        let values = [id, 0, habitname, image, averageCost, isDefault] as [AnyObject]
        
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        
        saveNewObjectForEntity(entity: .Habit, attributesDictionary: attributesDictionary)
        
    }
    
    //Edit an existing habit. Pass anything not changed as nil.
    
    func editExistingHabit(habitToEdit habitToEdit: Habit, newValue: Double?, newTitle: String?, newIcon: UIImage?) {
        
        let id = habitToEdit.id
        let count = habitToEdit.count
        
        var newName : String?
        var newCost : Double?
        var newPic : NSData?
        
        if let _ = newTitle {
            newName = newTitle
        } else {
            newName = habitToEdit.name
        }
        
        if let _ = newValue {
            newCost = newValue
        } else {
            newCost = habitToEdit.averageCost
        }
        
        if let tempIcon = newIcon {
            if let newIconData = UIImagePNGRepresentation(tempIcon) {
                newPic = newIconData
            }
        } else {
            newPic = habitToEdit.icon
        }
        
        let keys = ["averageCost", "icon", "name", "count", "id", "isDefault"] as [NSCopying]
        let values = [newCost!, newPic!, newName!, count, id, habitToEdit.isDefault] as [AnyObject]
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        
        editExistingObjectForEntity(entity: .Habit, id: habitToEdit.id, attributesDictionary: attributesDictionary)
    }
    
    //Call whenever a habit is used to increment the count
    
    func habitIsUsed(habitUsed habitUsed: Habit) {
        let count = habitUsed.count + 1
        
        let keys = ["averageCost", "icon", "name", "count", "id", "isDefault"] as [NSCopying]
        let values = [habitUsed.averageCost, habitUsed.icon, habitUsed.name, count, habitUsed.id, habitUsed.isDefault] as [AnyObject]
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        
        editExistingObjectForEntity(entity: .Habit, id: habitUsed.id, attributesDictionary: attributesDictionary)
    }
    
    //MARK: - Private Funcs
    
    //Returns array of Habits from CoreData
    
    private func fetchHabits() -> [Habit] {
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

