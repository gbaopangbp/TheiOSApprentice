//
//  AddItemViewController.swift
//  CheckLists
//
//  Created by cm on 15/12/28.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit


protocol AddItemProtocol:class{
    func addItemViewControllerDidCancel(controller:AddItemViewController)
    func addItemViewController(controller:AddItemViewController, didFinishAddindItem item:CheckListItem)
}

class AddItemViewController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate:AddItemProtocol?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    @IBAction func cancel(){
        delegate?.addItemViewControllerDidCancel(self)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(){
        let item = CheckListItem()
        item.text = textField.text!
        item.checked = false
        delegate?.addItemViewController(self, didFinishAddindItem: item)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            let oldText:NSString = NSString(string: textField.text!)
            let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
            
            doneBarButton.enabled = (newText.length > 0)
            return true
    }
}
