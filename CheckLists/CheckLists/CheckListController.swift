//
//  ViewController.swift
//  CheckLists
//
//  Created by cm on 15/12/22.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class CheckListController: UITableViewController,AddItemProtocol {
    var items:[CheckListItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [CheckListItem]()
        
        let row0Item = CheckListItem()
        row0Item.text = "Walk the dog"
        row0Item.checked = false
        items.append(row0Item)
        
        let row1Item = CheckListItem()
        row1Item.text = "Brush my teeth"
        row1Item.checked = true
        items.append(row1Item)

        
        let row2Item = CheckListItem()
        row2Item.text = "Learn iOS development"
        row2Item.checked = true
        items.append(row2Item)

        let row3Item = CheckListItem()
        row3Item.text = "Soccer practice"
        row3Item.checked = false
        items.append(row3Item)

        let row4Item = CheckListItem()
        row4Item.text = "Eat ice cream"
        row4Item.checked = true
        items.append(row4Item)
        
        super.init(coder: aDecoder)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let naviController = segue.destinationViewController as! UINavigationController
            let addController = naviController.topViewController as! AddItemViewController
            addController.delegate = self
        }
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem")
        
        let item:CheckListItem = items[indexPath.row]

        configLabelForCell(cell!, checkListItem: item)
        configCheckmarkForCell(cell!, checkListItem:item)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item:CheckListItem = items[indexPath.row]
            item.toggleChecked()
            configCheckmarkForCell(cell, checkListItem:item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            items.removeAtIndex(indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }
    
    func configCheckmarkForCell(cell:UITableViewCell, checkListItem item:CheckListItem)->Void{
        if item.checked{
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
    }
    
    func configLabelForCell(cell:UITableViewCell, checkListItem item:CheckListItem)->Void{
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishAddindItem item: CheckListItem) {
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: items.count - 1, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

