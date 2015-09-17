//
//  FrontPageViewController.swift
//  Pivit
//
//  Created by Jared on 9/11/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit
import CoreData

class FrontPageViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - Outlet Properties
    
    @IBOutlet weak var currentGoalLabel: UILabel!
    
    @IBOutlet weak var goalImage: UIImageView!
    
    @IBOutlet weak var progressBar: ASProgressPopUpView!

    @IBOutlet weak var whatsItForTextField: UITextField! {
        didSet {
            whatsItForTextField.delegate = self
        }
    }
    
    @IBOutlet weak var whatsItForAmountTextField: UITextField! {
        didSet {
            whatsItForAmountTextField.delegate = self
        }
    }
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var totalAmountNeededLabel: UILabel!
    
    @IBOutlet weak var logoView: UIView! {
        didSet {
            logoView.backgroundColor = PivitColor()
        }
    }
    
    //MARK: - Model
    
    private var goalHandler = GoalHandler()
    
    private var imageHandler = ImageHandler()
    
    //MARK: - Outlet Funcs
    
    @IBAction func submitCustomAmount(sender: UIButton) {

    }
    
    //MARK : - UITextField Funcs
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private Functions
    
    private func updateUI() {
        
        if let data = goalHandler.currentGoal?.picture {
            if let image = UIImage(data: data) {
                goalImage.image = image
            }
        } else {
            goalImage.image = imageHandler.generateClickToAddPhoto()
        }
        
        if let text = goalHandler.currentGoal?.title {
            currentGoalLabel.text = text
        } else {
            currentGoalLabel.text = "please set your goal!"
        }
        
        if let progress = goalHandler.currentGoal?.progress {
            progressBar.progress = Float(progress)
            progressLabel.text = "progress: $\(progress)"
        } else {
            progressBar.progress = Float(0)
            progressLabel.text = "progress: $0"
        }
        progressBar.showPopUpViewAnimated(true)
        progressBar.popUpView.cornerRadius = CGFloat(16.0)
        progressBar.popUpViewColor = PivitColor()
        
        if let money = goalHandler.currentGoal?.totalMoneyNeeded {
            totalAmountNeededLabel.text = "price: $\(money)"
        } else {
            totalAmountNeededLabel.text = "$0.00"
        }
        
    }

}

