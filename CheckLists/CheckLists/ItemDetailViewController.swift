//
//  ItemDetailViewController.swift
//  CheckLists
//
//  Created by cm on 15/12/28.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit


protocol ItemDetailProtocol:class{
    func itemDetailViewControllerDidCancel(controller:ItemDetailViewController)
    func itemDetailViewController(controller:ItemDetailViewController, didFinishAddindItem item:CheckListItem)
    func itemDetailViewController(controller:ItemDetailViewController, didFinishEditingItem item:CheckListItem)
}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var duteDataLabel: UILabel!
    
    weak var delegate:ItemDetailProtocol?
    weak var itemToEdit:CheckListItem?
    var dueDate = NSDate()
    var dateSelectionVisval = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editItem = itemToEdit {
            title = "EditItem"
            textField.text = editItem.text
            remindSwitch.on = editItem.shouleRemid
            dueDate = editItem.remindDate
        }
        updateDueDateLabel()
    }
    
    func updateDueDateLabel() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .ShortStyle
        duteDataLabel.text = dateFormatter.stringFromDate(dueDate)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && dateSelectionVisval {
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("dateSelectionCell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "dateSelectionCell")
            }
            cell?.selectionStyle = .None
            let picker = UIDatePicker(frame: CGRect(x: 0,y: 0,width: 320,height: 216))
            picker.tag = 100
            cell?.contentView.addSubview(picker)
            picker.addTarget(self, action: Selector("dateChange(:)"), forControlEvents: .ValueChanged)
            
            return cell!
        }else{
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        if indexPath.section == 1 && indexPath.row == 1 {
//            return indexPath
//        }else{
//            return nil
//        }
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 2 {
            showDatePicker()
        }
    }
    
//    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
//        var index = indexPath
//        if indexPath.section == 1 && indexPath.row == 2 {
//            index = NSIndexPath(forRow: 0, inSection: indexPath.section)
//        }
//        return super.tableView(tableView, indentationLevelForRowAtIndexPath: index)
//    }

    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(){
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouleRemid = remindSwitch.on
            item.remindDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }else{
            let item = CheckListItem()
            item.text = textField.text!
            item.checked = false
            item.shouleRemid = remindSwitch.on
            item.remindDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAddindItem: item)
        }
        
        

//        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            let oldText:NSString = NSString(string: textField.text!)
            let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
            
            doneBarButton.enabled = (newText.length > 0)
            return true
    }
    
    func dateChange(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    func showDatePicker() {
        dateSelectionVisval = true
        tableView.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchhhhhhh")
    }
}
