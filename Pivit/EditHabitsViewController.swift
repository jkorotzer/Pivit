//
//  EditHabitsViewController.swift
//  Pivit
//
//  Created by Jared on 9/24/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit

class EditHabitsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setIcons()
    }
    
    //MARK: - Model
    
    private let habits = HabitHandler().habits
    
    private var habitToEdit = Habit()
    
    //MARK: - Outlet Funcs
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Buttons
    
    @IBOutlet weak var firstHabitButton: UIButton! {
        didSet {
            firstHabitButton.tag = Tags.firstButtonTag
            firstHabitButton.addTarget(self, action: "habitSelected:", forControlEvents: .TouchUpInside)
        }
    }

    @IBOutlet weak var secondHabitButton: UIButton! {
        didSet {
            secondHabitButton.tag = Tags.secondButtonTag
            secondHabitButton.addTarget(self, action: "habitSelected:", forControlEvents: .TouchUpInside)
        }
    }
    
    @IBOutlet weak var thirdHabitButton: UIButton! {
        didSet {
            thirdHabitButton.tag = Tags.thirdButtonTag
            thirdHabitButton.addTarget(self, action: "habitSelected:", forControlEvents: .TouchUpInside)
        }
    }
    
    @IBOutlet weak var fourthHabitButton: UIButton! {
        didSet {
            fourthHabitButton.tag = Tags.fourthButtonTag
            fourthHabitButton.addTarget(self, action: "habitSelected:", forControlEvents: .TouchUpInside)
        }
    }
    
    @IBOutlet weak var fifthHabitButton: UIButton! {
        didSet {
            fifthHabitButton.tag = Tags.fifthButtonTag
            fifthHabitButton.addTarget(self, action: "habitSelected:", forControlEvents: .TouchUpInside)
        }
    }
    
    func habitSelected(sender: UIButton) {
        switch sender.tag {
        case Tags.firstButtonTag: habitToEdit = habits[0]
        case Tags.secondButtonTag: habitToEdit = habits[1]
        case Tags.thirdButtonTag: habitToEdit = habits[2]
        case Tags.fourthButtonTag: habitToEdit = habits[3]
        case Tags.fifthButtonTag: habitToEdit = habits[4]
        default: break
        }
        performSegueWithIdentifier("editHabit", sender: self)
    }
    
    //MARK: - Tags
    
    private struct Tags {
        static let firstButtonTag = 200
        static let secondButtonTag = 201
        static let thirdButtonTag = 202
        static let fourthButtonTag = 203
        static let fifthButtonTag = 204
    }
    
    private func setIcons() {
        let images = habits.map() {UIImage(data: $0.icon)}
        firstHabitButton.setImage(images[0], forState: .Normal)
        secondHabitButton.setImage(images[1], forState: .Normal)
        thirdHabitButton.setImage(images[2], forState: .Normal)
        fourthHabitButton.setImage(images[3], forState: .Normal)
        fifthHabitButton.setImage(images[4], forState: .Normal)
    }
    
}
