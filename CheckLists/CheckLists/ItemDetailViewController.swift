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
    
    weak var delegate:ItemDetailProtocol?
    weak var itemToEdit:CheckListItem?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editItem = itemToEdit {
            title = "EditItem"
            textField.text = editItem.text
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(){
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }else{
            let item = CheckListItem()
            item.text = textField.text!
            item.checked = false
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
}
