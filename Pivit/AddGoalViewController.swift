//
//  AddGoalViewController.swift
//  Pivit
//
//  Created by Jared on 9/16/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddGoalViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Model
    
    var handler = GoalHandler()
    
    //MARK : - Outlet Properties
    
    @IBOutlet weak var goalImage: UIImageView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
            goalImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBOutlet weak var goalNameTextField: HoshiTextField! {
        didSet {
            goalNameTextField.delegate = self
            goalNameTextField.borderStyle = .None
            goalNameTextField.placeholder = "name of your goal"
            goalNameTextField.placeholderColor = UIColor.lightGrayColor()
            goalNameTextField.borderInactiveColor = UIColor.darkGrayColor()
            goalNameTextField.borderActiveColor = PivitColor()
        }
    }
    
    @IBOutlet weak var goalAmountTextField: HoshiTextField! {
        didSet {
            goalAmountTextField.delegate = self
            goalAmountTextField.borderStyle = .None
            goalAmountTextField.placeholder = "$0.00"
            goalAmountTextField.placeholderColor = UIColor.lightGrayColor()
            goalAmountTextField.borderInactiveColor = UIColor.darkGrayColor()
            goalAmountTextField.borderActiveColor = PivitColor()
        }
    }
    
    //MARK : - TextField Funcs
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 180
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 180
    }
    
    //MARK: - Outlet Funcs

    @IBAction func saveNewGoal(sender: UIBarButtonItem) {
        
        print("save new goal")
        
        var picture: UIImage?
        var goalName: String?
        var goalMoneyNecessary: Double?
        
        if let image = goalImage.image {
            picture = image
        } else {
            //fix
        }
        
        if let money = Double(goalAmountTextField.text!) {
            goalMoneyNecessary = money
        }
        
        if let name = goalNameTextField.text {
            goalName = name
        }
        
        handler.saveNewGoal(goalName: goalName!, totalMoneyNeeded: goalMoneyNecessary!, picture: picture!)
    }
    
    //MARK: - UIPickerController Handling
    
    func imageTapped(img: AnyObject) {
        let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        photoActionSheet.addAction(UIAlertAction(title: "Take Photo", style: .Default)
            {[unowned self] (action: UIAlertAction) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    let picker = UIImagePickerController()
                    picker.navigationBar.tintColor = UIColor.whiteColor()
                    picker.sourceType = .Camera
                    picker.mediaTypes = [String(kUTTypeImage)]
                    picker.allowsEditing = true
                    picker.delegate = self
                    self.presentViewController(picker, animated: true, completion: nil)
                }
            })
        photoActionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .Default)
            {[unowned self](action: UIAlertAction) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                    let picker = UIImagePickerController()
                    picker.navigationBar.tintColor = UIColor.whiteColor()
                    picker.sourceType = .PhotoLibrary
                    picker.mediaTypes = [String(kUTTypeImage)]
                    picker.allowsEditing = true
                    picker.delegate = self
                    self.presentViewController(picker, animated: true, completion: nil)
                }
            })
        photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(photoActionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        goalImage.image = image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
