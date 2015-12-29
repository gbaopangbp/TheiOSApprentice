//
//  AllListViewController.swift
//  CheckLists
//
//  Created by cm on 15/12/29.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController,ListDetailControllerProtocol,UINavigationControllerDelegate {
    var dataModel:DataModel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = NSUserDefaults.standardUserDefaults().integerForKey("CheckListIndex")
        if index != -1 {
            performSegueWithIdentifier("ShowCheckList", sender: dataModel.lists[index])
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CheckListCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CheckListCell")
        }
        let list = dataModel.lists[indexPath.row] as CheckList
        cell.textLabel?.text = list.name
        cell.accessoryType = .DetailDisclosureButton
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "CheckListIndex")

        performSegueWithIdentifier("ShowCheckList", sender: dataModel.lists[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let naviController = storyboard?.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        
        let detailCheckController = naviController.topViewController as! ListDetailControllrer
        detailCheckController.delegate = self
        detailCheckController.list = dataModel.lists[indexPath.row]
        presentViewController(naviController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataModel.lists.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCheckList" {
            let controller = segue.destinationViewController as! CheckListController
            controller.checkList = sender as! CheckList
            
        }else if segue.identifier == "AddCheckList" {
            let naviController = segue.destinationViewController as! UINavigationController
            let detailController = naviController.topViewController as! ListDetailControllrer
            detailController.delegate = self
            detailController.list = nil
        }
    }
    
    func listDetailControllerCancel(controller: ListDetailControllrer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailController(controller: ListDetailControllrer, didFinishEditingList list: CheckList) {
        let index = dataModel.lists.indexOf(list)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        let indexPaths = [indexPath]
        tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func listDetailController(controller: ListDetailControllrer, didFinishAddingList list: CheckList) {
        dataModel.lists.append(list)
        let indexPath = NSIndexPath(forRow: dataModel.lists.count - 1, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if self == viewController {
            NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: "CheckListIndex")
        }
    }

    
    
}
