//
//  EditHabitsViewController.swift
//  Pivit
//
//  Created by Jared on 9/24/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import UIKit

class EditHabitsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Outlet Funcs
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
