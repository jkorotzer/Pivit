//
//  GoalHandler.swift
//  Pivit
//
//  Created by Jared on 9/17/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import Foundation
import CoreData

//Handles everything to do with goals and acts as model for view controllers. Variables Goals and currentGoal are read only, do not mutate them unless by a public function.

class GoalHandler: CoreDataHandler {
    
    //MARK: - Properties
    
    var Goals: [Goal] {
        get {
            return fetchGoals()
        }
    }
    
    var currentGoal: Goal? {
        get {
            if Goals.count == 1 {
                setNewCurrentGoal(newCurrentGoal: Goals[0])
            }
            for goal in Goals {
                if goal.isCurrentGoal {
                    return goal
                }
            }
        return nil
        }
    }
    
    //MARK: - Public Functions
    
    //Use to save a new goal to core data
    
    func saveNewGoal(goalName goalname: String, totalMoneyNeeded: Double, picture: UIImage) {
        
        let image = UIImagePNGRepresentation(picture)!
        let id = NSUUID().UUIDString
        
        let keys = ["id", "dateStarted", "currentGoal", "progress", "title", "picture", "totalMoneyNeeded", "isFinished"] as [NSCopying]
        let values = [id, NSDate(), NSNumber(bool: true), 0.0, goalname, image, totalMoneyNeeded, false] as [AnyObject]
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        
        saveNewObjectForEntity(entity: .Goal, attributesDictionary: attributesDictionary)
        
        if let goal = getSpecificGoalbyId(id: id) {
            setNewCurrentGoal(newCurrentGoal: goal)
        }
        
    }
    
    //Use to set a different goal as the user's current goal. Do not use on a finished goal!
    
    func setNewCurrentGoal(newCurrentGoal newCurrentGoal: Goal) {
        
        if newCurrentGoal.isFinished {
            return
        }
        
        let keys = ["id", "dateStarted", "currentGoal", "progress", "title", "picture", "totalMoneyNeeded", "isFinished"] as [NSCopying]
        
        for goal in Goals {
            if goal.id == newCurrentGoal.id {
                let values = [goal.id, goal.dateStarted, NSNumber(bool: true), goal.progress, goal.title, goal.picture, goal.totalMoneyNeeded, goal.isFinished] as [AnyObject]
                let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
                editExistingObjectForEntity(entity: .Goal, id: goal.id, attributesDictionary: attributesDictionary)
            } else {
                if goal.isCurrentGoal {
                    let values = [goal.id, goal.dateStarted, NSNumber(bool: false), goal.progress, goal.title, goal.picture, goal.totalMoneyNeeded, goal.isFinished] as [AnyObject]
                    let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
                    editExistingObjectForEntity(entity: .Goal, id: goal.id, attributesDictionary: attributesDictionary)
                }
            }
        }
    }
    
    //Use to edit an existing goal in core data. Pass any arguments that are not to be changed as nil. You cannot use it to reset current goal, or to push money to a goal.
    
    func editExistingGoal(goalToEdit goalToEdit: Goal, newTitle: String?, newPicture: UIImage?, newTotalMoneyNeeded: Double?) {
        
        let id = goalToEdit.id
        let dateStarted = goalToEdit.dateStarted
        let isCurrentGoal = goalToEdit.currentGoal
        let progress = goalToEdit.progress
        let finished = goalToEdit.isFinished
        
        var title: String?
        var picture: NSData?
        var totalMoneyNeeded: Double?
        
        if let tempTitle = newTitle {
            title = tempTitle
        } else {
            title = goalToEdit.title
        }
        
        if let tempPicture = newPicture {
            picture = UIImagePNGRepresentation(tempPicture)
        } else {
            picture = goalToEdit.picture
        }
        
        if let tempMoney = newTotalMoneyNeeded {
            totalMoneyNeeded = tempMoney
        } else {
            totalMoneyNeeded = goalToEdit.totalMoneyNeeded
        }
        
        let keys = ["id", "dateStarted", "currentGoal", "progress", "title", "picture", "totalMoneyNeeded", "isFinished"] as [NSCopying]
        let values = [id, dateStarted, isCurrentGoal, progress, title!, picture!, totalMoneyNeeded!, finished] as [AnyObject]
        let attributesDict = NSDictionary(objects: values, forKeys: keys)
        
        editExistingObjectForEntity(entity: .Goal, id: id, attributesDictionary: attributesDict)
        
    }
    
    //Use to push money to current goal for the custom amount
    
    func pushMoneyToCurrentGoal(moneyToPush moneyToPush: Double) {
        if let goal = currentGoal {
        pushMoneyToGoal(goal: goal, moneyToPush: moneyToPush)
        }
    }
    
    //Use to push money from a shortcut
    
    func pushMoneyToCurrentGoalFromHabit(habit habit: Habit) {
        if let goal = currentGoal {
            let habitHandler = HabitHandler()
            habitHandler.habitIsUsed(habitUsed: habit)
            pushMoneyToGoal(goal: goal, moneyToPush: habit.averageCost)
        }
    }
    
    //Use to set a finished goal to finished. Also sets the goal as NOT the current goal!
    
    func setGoalIsFinished(finishedGoal finishedGoal: Goal) {
        let keys = ["id", "dateStarted", "currentGoal", "progress", "title", "picture", "totalMoneyNeeded", "isFinished"] as [NSCopying]
        let values = [finishedGoal.id, finishedGoal.dateStarted, false, finishedGoal.progress, finishedGoal.title, finishedGoal.picture, finishedGoal.totalMoneyNeeded, true]
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        editExistingObjectForEntity(entity: .Goal, id: finishedGoal.id, attributesDictionary: attributesDictionary)
    }
    
    func goalIsFinished(goalToCheck goalToCheck: Goal) -> Bool {
        if goalToCheck.progress >= goalToCheck.totalMoneyNeeded {
            return true
        }
        return false
    }
    
    //MARK: - Private funcs
    
    //Use to push money to a specific goal.
    
    private func pushMoneyToGoal(goal goal: Goal, moneyToPush: Double) {
        
        var progress = goal.progress
        progress += moneyToPush
        
        let keys = ["id", "dateStarted", "currentGoal", "progress", "title", "picture", "totalMoneyNeeded", "isFinished"] as [NSCopying]
        let values = [goal.id, goal.dateStarted, goal.currentGoal, progress, goal.title, goal.picture, goal.totalMoneyNeeded, goal.isFinished] as [AnyObject]
        let attributesDictionary = NSDictionary(objects: values, forKeys: keys)
        
        editExistingObjectForEntity(entity: .Goal, id: goal.id, attributesDictionary: attributesDictionary)
    }
    
    private func getSpecificGoalbyId(id id: String) -> Goal? {
        if Goals.count > 0 {
            for goal in Goals {
                if goal.id == id {
                    return goal
                }
            }
        }
        return nil
    }
    
    private func fetchGoals() -> [Goal] {
        var Goals = [Goal]()
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Goal")
        request.returnsObjectsAsFaults = false
        do {
            Goals = try context.executeFetchRequest(request) as! [Goal]
        } catch {
            print ("error")
        }
        return Goals
    }
    
}