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
        let tapped = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        tapped.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapped)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Model
    
    private var handler = GoalHandler()
    
    private var imageHandler = ImageHandler()
    
    private var userIsEditing: Bool = false
    
    private var currentString = ""
    
    private var keyBoard = false
    
    var goalBeingEdited: Goal? {
        didSet {
            userIsEditing = true
        }
    }
    
    //MARK: - Outlet Properties
        
    @IBOutlet weak var goalImage: UIImageView! {
        didSet {
            if !userIsEditing {
                goalImage.image = imageHandler.generateClickToAddPhoto()
            } else {
                if let goal = goalBeingEdited {
                    goalImage.image = UIImage(data: goal.picture)
                }
            }
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
            if userIsEditing {
                if let goal = goalBeingEdited {
                    goalNameTextField.text = goal.title
                }
            }
        }
    }
    
    @IBOutlet weak var goalAmountTextField: HoshiTextField! {
        didSet {
            goalAmountTextField.delegate = self
            goalAmountTextField.tag = 200
            goalAmountTextField.borderStyle = .None
            goalAmountTextField.placeholder = "$0.00"
            goalAmountTextField.placeholderColor = UIColor.lightGrayColor()
            goalAmountTextField.borderInactiveColor = UIColor.darkGrayColor()
            goalAmountTextField.borderActiveColor = PivitColor()
            goalAmountTextField.keyboardType = UIKeyboardType.NumberPad
            if userIsEditing {
                if let goal = goalBeingEdited {
                    currentString = "\(goal.totalMoneyNeeded)".stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString(".", withString: "") + "0"
                    formatCurrency(string: currentString)
                }
            }
        }
    }
    
    //MARK: - TextField Funcs
    
    func closeKeyboard() {
            self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if !keyBoard {
            self.view.frame.origin.y -= 200
        }
        keyBoard = true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if keyBoard {
            self.view.frame.origin.y += 200
        }
        keyBoard = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 200 {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                if textField.text?.characters.count > 7 {
                    return false
                }
                currentString += string
                formatCurrency(string: currentString)
            default:
                let array = Array(arrayLiteral: string)
                var currentStringArray = Array(arrayLiteral: currentString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    currentString = ""
                    for character in currentStringArray {
                        currentString += String(character)
                    }
                    formatCurrency(string: currentString)
                } else {
                    if currentString.characters.count<=1 {
                        currentString=""
                        formatCurrency(string: currentString)
                    } else {
                        let endIndex = currentString.endIndex
                        let lastCharacterIndex = endIndex.advancedBy(-1)
                        currentString.removeAtIndex(lastCharacterIndex)
                        formatCurrency(string: currentString)
                    }
                    
                }
            }
            return false
        } else {
            let  char = string.cStringUsingEncoding(NSUTF8StringEncoding)!
            let isBackSpace = strcmp(char, "\\b")
            if !(isBackSpace == -92) &&  textField.text?.characters.count > 25 {
                return false
            } else {
                return true
            }
            
        }
    }
    
    func formatCurrency(string string: String) {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        goalAmountTextField.text = formatter.stringFromNumber(numberFromField)
    }

    
    //MARK: - Outlet Funcs
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        goalNameTextField.resignFirstResponder()
        goalAmountTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func done(sender: UIBarButtonItem) {
        
        if let picture = goalImage.image {
            if let currentString = goalAmountTextField.text {
                if let money = sanitizeMoney(string: currentString) {
                    if let name = goalNameTextField.text {
                        if userIsEditing {
                            if let goal = goalBeingEdited {
                                if !goal.isFinished {
                                    handler.editExistingGoal(goalToEdit: goal, newTitle: name, newPicture: picture, newTotalMoneyNeeded: money)
                                }
                            }
                        } else {
                            handler.saveNewGoal(goalName: name, totalMoneyNeeded: money, picture: picture)
                        }
                        goalNameTextField.resignFirstResponder()
                        goalAmountTextField.resignFirstResponder()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    //MARK: - UIPickerController Handling
    
    func imageTapped(img: AnyObject) {
        if keyBoard {
            closeKeyboard()
        } else {
            let photoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            photoActionSheet.addAction(UIAlertAction(title: "Take Photo", style: .Default)
                {[unowned self] (action: UIAlertAction) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    self.presentPickerController(.Camera)
                    }
                })
            photoActionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .Default)
                {[unowned self](action: UIAlertAction) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                    self.presentPickerController(.PhotoLibrary)
                    }
                })
            photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(photoActionSheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        goalImage.image = image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func presentPickerController(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.navigationBar.tintColor = UIColor.whiteColor()
        picker.sourceType = sourceType
        picker.mediaTypes = [String(kUTTypeImage)]
        picker.allowsEditing = true
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
}


