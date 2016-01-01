//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by yaoyingtao on 16/1/1.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    
    var selectIndexPath = NSIndexPath()
    var selectCategoryName = ""
    var categoryNames = ["No Category", "Apple Store", "Bar", "Bookstore", "Club",
        "Grocery Store", "Historic Building", "House",
        "Icecream Vendor", "Landmark",
        "Park"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)

        cell.textLabel?.text = categoryNames[indexPath.row]
            if categoryNames[indexPath.row] == selectCategoryName {
            cell.accessoryType = .Checkmark
            selectIndexPath = indexPath
        } else {
            cell.accessoryType = .None
            }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if selectIndexPath.row != indexPath.row {
                selectCategoryName = categoryNames[indexPath.row]
                let newCell = tableView.cellForRowAtIndexPath(indexPath)
                newCell?.accessoryType = .Checkmark
            if let oldCell = tableView.cellForRowAtIndexPath(selectIndexPath){
                    oldCell.accessoryType = .None
                }

                selectIndexPath = indexPath
            }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DidCategory" {
        let cell = sender as!UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            selectCategoryName = categoryNames[indexPath!.row]
    }
    }

}
