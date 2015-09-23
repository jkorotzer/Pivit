//
//  GoalTableViewCell.swift
//  Pivit
//
//  Created by Jared on 9/12/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit

protocol GoalTableViewCellTableView: class {
    func saveNewCurrentGoal(sender: UITableViewCell)
}

class GoalTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - Model
    
    var goal: Goal? {
        didSet {
            updateUI()
        }
    }
    
    weak var delegate: GoalTableViewCellTableView?
        
    //MARK: - Outlet Properties
    
    @IBOutlet weak var progressView: ASProgressPopUpView! {
        didSet {
            progressView.showPopUpViewAnimated(true)
            progressView.popUpView.cornerRadius = CGFloat(16.0)
            progressView.popUpViewColor = PivitColor()
        }
        
    }
    
    @IBOutlet weak var goalTimeLabel: UILabel!
    
    @IBOutlet weak var goalNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var goalImageView: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    //MARK: - Private funcs
    
    private func updateUI() {
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        
        goalNameLabel.text = goal!.title
        goalTimeLabel.text = getDate(time: goal!.dateStarted)
        
        progressLabel.text = "\(numberFormatter.stringFromNumber(goal!.progress)!)"
        progressView.progress = Float(goal!.progress)
        
        
    }
    
    private func getDate(time time: NSDate) -> String
    {
        let timeAfterStart = Int(NSDate().timeIntervalSinceDate(time))
        if(timeAfterStart < 60){
            if(timeAfterStart==1){
                return "" +  String(timeAfterStart) + " second"
            }
            return "" +  String(timeAfterStart) + " seconds"
        }
        else if(timeAfterStart < 3600){
            let minutes = timeAfterStart/60
            if(minutes==1){
                return "" +  String(minutes) + " minute"
            }
            return "" + String(minutes) + " minutes"
        }
        else if(timeAfterStart < 86400)
        {
            let hours = timeAfterStart/3600
            if(hours==1){
                return "" +  String(hours) + " hour"
            }
            return "" + String(hours) + " hours"
        }
        else
        {
            let days = timeAfterStart/86400
            if(days==1){
                return "" + String(days) + " day"
            }
            return "" + String(days) + " days"
        }
        
    }
    
}
