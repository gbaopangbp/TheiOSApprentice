//
//  ViewController.swift
//  CheckLists
//
//  Created by cm on 15/12/22.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class CheckListController: UITableViewController,ItemDetailProtocol {
    var checkList:CheckList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 44
        title = checkList.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ItemDetail" {
            let naviController = segue.destinationViewController as! UINavigationController
            let addController = naviController.topViewController as! ItemDetailViewController
            addController.delegate = self
        }else if segue.identifier == "EditItem" {
            let naviController = segue.destinationViewController as! UINavigationController
            let addController = naviController.topViewController as! ItemDetailViewController
            addController.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                addController.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem")
        
        let item:CheckListItem = checkList.items[indexPath.row]

        configLabelForCell(cell!, checkListItem: item)
        configCheckmarkForCell(cell!, checkListItem:item)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item:CheckListItem = checkList.items[indexPath.row]
            item.toggleChecked()
            configCheckmarkForCell(cell, checkListItem:item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            checkList.items.removeAtIndex(indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }
    
    func configCheckmarkForCell(cell:UITableViewCell, checkListItem item:CheckListItem)->Void{
        let checkLabel = cell.viewWithTag(1001) as! UILabel
        checkLabel.tintColor = view.tintColor
        if item.checked{
            checkLabel.text = "√"
        }else{
            checkLabel.text = ""
        }
    }
    
    func configLabelForCell(cell:UITableViewCell, checkListItem item:CheckListItem)->Void{
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        label.textColor = view.tintColor
    }
    
    func itemDetailViewController(controller:ItemDetailViewController, didFinishEditingItem item:CheckListItem){
        if let index = checkList.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configLabelForCell(cell, checkListItem: item)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddindItem item: CheckListItem) {
        checkList.items.append(item)
        
        let indexPath = NSIndexPath(forRow: checkList.items.count - 1, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

