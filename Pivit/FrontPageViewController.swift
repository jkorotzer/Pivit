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
    
    private var currentString = ""
    private var KeyBoard = false
   
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        let tapped = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        tapped.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapped)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
            whatsItForAmountTextField.tag=100
            whatsItForAmountTextField.delegate = self
            whatsItForAmountTextField.keyboardType=UIKeyboardType.NumberPad
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
        if let text = whatsItForAmountTextField.text {
            if let moneyToPush = sanitizeMoney(string: text) {
                goalHandler.pushMoneyToCurrentGoal(moneyToPush: moneyToPush)
            }
        }
        currentString = ""
        formatCurrency(string: currentString)
        whatsItForTextField.text = ""
        updateUI()
    }
    
    //MARK : - UITextField Funcs
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        KeyBoard = true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        KeyBoard = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 100 {
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
        else {
            let  char = string.cStringUsingEncoding(NSUTF8StringEncoding)!
            let isBackSpace = strcmp(char, "\\b")
            if !(isBackSpace == -92) &&  textField.text?.characters.count > 25{
                return false
            }
            else {
                return true
            }

        }
    }
    
    
    
    func formatCurrency(string string: String) {
        print("format \(string)")
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        whatsItForAmountTextField.text = formatter.stringFromNumber(numberFromField)
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
        
        if let currentGoal = goalHandler.currentGoal {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        
        let data = currentGoal.picture
        let image = UIImage(data: data)
        goalImage.image = image
            
        currentGoalLabel.text = currentGoal.title
            
        let progress = currentGoal.progress
        let progressPercentage = (progress / currentGoal.totalMoneyNeeded)
        progressBar.setProgress(Float(progressPercentage), animated: true)
        let progressNum = numberFormatter.stringFromNumber(progress)!
        progressLabel.text = "progress: \(progressNum)"
        progressBar.showPopUpViewAnimated(true)
        progressBar.popUpView.cornerRadius = CGFloat(16.0)
        progressBar.popUpViewColor = PivitColor()
        progressBar.progressTintColor = PivitColor()
        
        let money = currentGoal.totalMoneyNeeded
        let moneyNum = numberFormatter.stringFromNumber(money)!
        totalAmountNeededLabel.text = "price: \(moneyNum)"
    
        } else {
            goalImage.image = imageHandler.generateClickToAddPhoto()
            currentGoalLabel.text = "please set your goal"
            progressBar.progress = Float(0)
            progressLabel.text = "progress: $0.00"
            totalAmountNeededLabel.text = "$0.00"
        }
        
    }
}

