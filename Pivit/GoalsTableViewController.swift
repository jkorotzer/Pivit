//
//  GoalsTableViewController.swift
//  Pivit
//
//  Created by Jared on 9/12/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = self.tableView.frame.size.height - self.navigationController!.navigationBar.frame.size.height - tabBar.tabBar.frame.size.height - CGFloat(30.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        localGoalsIsSelected = true
        reloadTableView()
    }

    //MARK: - Outlet Properties
    
    @IBOutlet weak var navigationView: UIView! {
        didSet {
            navigationView.backgroundColor = UIColor.clearColor()
        }
    }
    
    @IBOutlet weak var meButton: UIButton! {
        didSet {
            meButton.layer.borderColor = UIColor.whiteColor().CGColor
            meButton.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var friendsButton: UIButton! {
        didSet {
            friendsButton.layer.borderColor = UIColor.whiteColor().CGColor
            friendsButton.layer.cornerRadius = 5.0
        }
    }
    
    //MARK: - Outlet Funcs
    
    @IBAction func myGoalsSelected(sender: UIButton) {
        localGoalsIsSelected = true
        reloadTableView()
    }
    
    @IBAction func friendsGoalsSelected(sender: AnyObject) {
        localGoalsIsSelected = false
        reloadTableView()
    }
    
    
    //MARK: - Model
    
    private var goalHandler = GoalHandler()
    
    private var goals = [Goal]()
    
    private var goalImages = [UIImage]()
    
    private var localGoalsIsSelected = true {
        didSet {
            if localGoalsIsSelected {
                meButton.setTitleColor(PivitColor(), forState: .Normal)
                meButton.backgroundColor = UIColor.whiteColor()
                friendsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                friendsButton.backgroundColor = UIColor.clearColor()
            } else {
                meButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                meButton.backgroundColor = UIColor.clearColor()
                friendsButton.setTitleColor(PivitColor(), forState: .Normal)
                friendsButton.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if localGoalsIsSelected {
            return goals.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardKeys.GoalCell, forIndexPath: indexPath) as? GoalTableViewCell {
            //cell.delegate = self
            cell.goal = goals[indexPath.row]
            cell.goalImageView.image = goalImages[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private Funcs
    
    private func reloadTableView() {
        setModel()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    private func setModel() {
        goals = goalHandler.Goals
        goalImages = [UIImage]()
        for goal in goals {
            goalImages.append(UIImage(data: goal.picture)!)
        }
    }
    
    //MARK: - Constants
    
    private let tabBar = UITabBarController()
    
    private struct StoryboardKeys {
        static let GoalCell = "GoalCell"
    }

}
