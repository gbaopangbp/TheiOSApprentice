//
//  PickIconViewController.swift
//  CheckLists
//
//  Created by yaoyingtao on 15/12/29.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

protocol PickIconViewControllerProtocol:class{
    func pickIconController(controller:PickIconViewController ,didPickIcon iconName:String)
}

class PickIconViewController: UITableViewController {
    var icons = ["No Icon",
        "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries","Inbox", "Photos", "Trips"];
    
    weak var delegate:PickIconViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PickIconCell", forIndexPath: indexPath)

        cell.textLabel?.text = icons[indexPath.row]
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.pickIconController(self, didPickIcon: icons[indexPath.row])
    }
    
}
