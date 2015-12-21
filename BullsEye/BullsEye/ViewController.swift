//
//  ViewController.swift
//  BullsEye
//
//  Created by cm on 15/12/21.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentValue:Int = 50
    var targetValue:Int = 0

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewRound()
        updateTargetLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(sender: AnyObject) {
        let message = "The slider value is:\(currentValue)" + "\nThe target is:\(targetValue)"
        let alert = UIAlertController(title: "Hello ,World", message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
        startNewRound()
        updateTargetLabel()
    }

    @IBAction func sliderMoved(sender: UISlider) {
        print("The slider value is: \(sender.value)")
        currentValue = lroundf(sender.value)
    }
    
    func startNewRound(){
        currentValue = 50
        targetValue = Int(1 + arc4random_uniform(100))
        slider.value = Float(currentValue)
    }
    
    func updateTargetLabel(){
        targetLabel.text = String(targetValue)
    }
}

