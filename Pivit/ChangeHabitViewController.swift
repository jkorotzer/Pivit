//
//  ChangeHabitViewController.swift
//  Pivit
//
//  Created by Jared on 10/13/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit
import MobileCoreServices

class ChangeHabitViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        let tapped = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        tapped.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapped)
    }
    
    //MARK: - Model
    
    var habitToBeEdited: Habit?
    
    private var keyBoard = false
    
    private var currentString = ""
    
    //MARK: - Outlet Properties
    
    @IBOutlet weak var habitImageView: UIImageView! {
        didSet {
            if let habit = habitToBeEdited {
                habitImageView.image = UIImage(data: habit.icon)
            }
            let tapper = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
            habitImageView.addGestureRecognizer(tapper)
        }
    }
    
    @IBOutlet weak var habitNameTextField: HoshiTextField! {
        didSet {
            habitNameTextField.delegate = self
            habitNameTextField.borderStyle = .None
            habitNameTextField.placeholder = "name of your habit"
            habitNameTextField.placeholderColor = UIColor.lightGrayColor()
            habitNameTextField.borderActiveColor = PivitColor()
            habitNameTextField.borderInactiveColor = UIColor.darkGrayColor()
            if let habit = habitToBeEdited {
                habitNameTextField.text = habit.name
            }
        }
    }
    
    @IBOutlet weak var habitCostTextField: HoshiTextField! {
        didSet {
            habitCostTextField.delegate = self
            habitCostTextField.tag = 200
            habitCostTextField.borderStyle = .None
            habitCostTextField.placeholder = "cost of your habit"
            habitCostTextField.placeholderColor = UIColor.lightGrayColor()
            habitCostTextField.borderInactiveColor = UIColor.darkGrayColor()
            habitCostTextField.borderActiveColor = PivitColor()
            habitCostTextField.keyboardType = .NumberPad
            if let habit = habitToBeEdited {
                currentString = "\(habit.averageCost)".stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(".", withString: "").stringByReplacingOccurrencesOfString(",", withString: "") + "0"
                formatCurrency(string: currentString)
            }
        }
    }
    
    //MARK: - Outlet Funcs
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if let habit = habitToBeEdited {
            if let icon = habitImageView.image {
                if let cost = sanitizeMoney(string: habitCostTextField.text!) {
                    if let name = habitNameTextField.text {
                        HabitHandler().editExistingHabit(habitToEdit: habit, newValue: cost, newTitle: name, newIcon: icon)
                    }
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
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
            self.view.frame.origin.y -= 50
        }
        keyBoard = true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if keyBoard {
            self.view.frame.origin.y += 50
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
                print(currentString)
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
        habitCostTextField.text = formatter.stringFromNumber(numberFromField)
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
        let maskedImage = Toucan.Mask.maskImageWithEllipse(image!)
        habitImageView.image = maskedImage
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
