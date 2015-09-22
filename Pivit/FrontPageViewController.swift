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
    var currentString = ""
    
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
            whatsItForAmountTextField.tag=100
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
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 100 {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            print(currentString)
            formatCurrency(string: currentString)
        case "delete":
            print("NICE")
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
                print("HI")
                let letters = NSCharacterSet.letterCharacterSet()
                for letter in string.unicodeScalars {
                    if !letters.longCharacterIsMember(letter.value) {
                        currentStringArray.removeLast()
                        currentString = ""
                        for character in currentStringArray {
                            currentString += String(character)
                        }
                        formatCurrency(string: currentString)
                    }
                }
            }
            }
        }
        return false
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
        
        let currentGoal : Goal? = goalHandler.currentGoal
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        
        if let data = currentGoal?.picture {
            if let image = UIImage(data: data) {
                goalImage.image = image
            }
        } else {
            goalImage.image = imageHandler.generateClickToAddPhoto()
        }
        
        if let text = currentGoal?.title {
            currentGoalLabel.text = text
        } else {
            currentGoalLabel.text = "please set your goal!"
        }
        
        if let progress = currentGoal?.progress {
            progressBar.progress = Float(progress)
            let progressNum = numberFormatter.stringFromNumber(progress)!
            progressLabel.text = "progress: \(progressNum)"
        } else {
            progressBar.progress = Float(0)
            progressLabel.text = "progress: $0.00"
        }
        progressBar.showPopUpViewAnimated(true)
        progressBar.popUpView.cornerRadius = CGFloat(16.0)
        progressBar.popUpViewColor = PivitColor()
        
        if let money = currentGoal?.totalMoneyNeeded {
            let moneyNum = numberFormatter.stringFromNumber(money)!
            totalAmountNeededLabel.text = "price: \(moneyNum)"
        } else {
            totalAmountNeededLabel.text = "$0.00"
        }
        
    }

}

