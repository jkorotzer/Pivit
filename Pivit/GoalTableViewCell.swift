//
//  GoalTableViewCell.swift
//  Pivit
//
//  Created by Jared on 9/12/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Outlet Properties
    
    @IBOutlet weak var progressView: ASProgressPopUpView! {
        didSet {
            progressView.progress = Float(0.3)
            progressView.showPopUpViewAnimated(true)
            progressView.popUpView.cornerRadius = CGFloat(16.0)
            progressView.popUpViewColor = PivitColor()
        }
        
    }
    
    @IBOutlet weak var goalNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var goalImageView: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
}
