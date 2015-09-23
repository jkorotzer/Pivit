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
    
    var currentString = ""
    
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
    
    //MARK : - Outlet Properties
    
    @IBOutlet weak var goalImage: UIImageView! {
        didSet {
            goalImage.image = imageHandler.generateClickToAddPhoto()
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
    
    @IBOutlet weak var goalAmountTextField: HoshiTextField!{
        didSet{
            goalAmountTextField.delegate = self
            goalAmountTextField.tag = 200
            goalAmountTextField.borderStyle = .None
            goalAmountTextField.placeholder = "$0.00"
            goalAmountTextField.placeholderColor = UIColor.lightGrayColor()
            goalAmountTextField.borderInactiveColor = UIColor.darkGrayColor()
            goalAmountTextField.borderActiveColor = PivitColor()
            goalAmountTextField.keyboardType = UIKeyboardType.NumberPad
        }
    }
    
    //MARK : - TextField Funcs
    
    func closeKeyboard(){
            self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 200
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 200
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
        }
        else{
            let  char = string.cStringUsingEncoding(NSUTF8StringEncoding)!
            let isBackSpace = strcmp(char, "\\b")
            if !(isBackSpace == -92) &&  textField.text?.characters.count > 25{
                return false
            }
            else{
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
        var goalName: String?
        var goalMoneyNecessary: Double?
        
        let picture = goalImage.image
        
        if let currentString = goalAmountTextField.text {
            let moneyString = currentString.stringByReplacingOccurrencesOfString("$", withString: "")
            if let money = Double(moneyString) {
                goalMoneyNecessary = money
            }
        }
        
        if let name = goalNameTextField.text {
            goalName = name
        }
        
        handler.saveNewGoal(goalName: goalName!, totalMoneyNeeded: goalMoneyNecessary!, picture: picture!)
        
        goalNameTextField.resignFirstResponder()
        goalAmountTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - UIPickerController Handling
    
    func imageTapped(img: AnyObject) {
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


