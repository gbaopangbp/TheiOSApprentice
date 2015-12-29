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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfCheckList
        if index >= 0 && index < dataModel.lists.count {
            performSegueWithIdentifier("ShowCheckList", sender: dataModel.lists[index])
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CheckListCell")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "CheckListCell")
        }
        let list = dataModel.lists[indexPath.row] as CheckList
        cell.textLabel?.text = list.name
        cell.accessoryType = .DetailDisclosureButton
        let count = list.countOfUncheckedItems()
        if list.items.count == 0{
            cell.detailTextLabel?.text = "No Item"
        }else if count > 0{
            cell.detailTextLabel?.text = "\(count) Reminding"
        }else{
            cell.detailTextLabel?.text = "All Done"
        }
        
        cell.imageView?.image = UIImage(named: list.iconName)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfCheckList = indexPath.row
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
        dataModel.sortCheckLists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func listDetailController(controller: ListDetailControllrer, didFinishAddingList list: CheckList) {
        dataModel.lists.append(list)
        dataModel.sortCheckLists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if self == viewController {
            dataModel.indexOfCheckList = -1
        }
    }

    
    
}
