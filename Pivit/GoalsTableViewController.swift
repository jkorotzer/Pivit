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
        self.tableView.rowHeight = self.tableView.frame.size.height - self.navigationController!.navigationBar.frame.size.height - tabBar.tabBar.frame.size.height - CGFloat(30.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }

    //MARK: - Model
    
    private var goalHandler = GoalHandler()
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalHandler.Goals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardKeys.GoalCell, forIndexPath: indexPath) as? GoalTableViewCell {
            cell.goal = goalHandler.Goals[indexPath.row]
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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    //MARK: - Constants
    
    private let tabBar = UITabBarController()
    
    private struct StoryboardKeys {
        static let GoalCell = "GoalCell"
    }

}
