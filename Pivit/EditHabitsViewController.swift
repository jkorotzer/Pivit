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
    
    private var habits = HabitHandler().habits
    
    //MARK: - Outlet Funcs
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Buttons
    
    @IBOutlet weak var firstHabitButton: UIButton! {
        didSet {
            firstHabitButton.tag = Tags.firstButtonTag
        }
    }

    @IBOutlet weak var secondHabitButton: UIButton! {
        didSet {
            secondHabitButton.tag = Tags.secondButtonTag
        }
    }
    
    @IBOutlet weak var thirdHabitButton: UIButton! {
        didSet {
            thirdHabitButton.tag = Tags.thirdButtonTag
        }
    }
    
    @IBOutlet weak var fourthHabitButton: UIButton! {
        didSet {
            fourthHabitButton.tag = Tags.fourthButtonTag
        }
    }
    
    @IBOutlet weak var fifthHabitButton: UIButton! {
        didSet {
            fifthHabitButton.tag = Tags.fifthButtonTag
        }
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
