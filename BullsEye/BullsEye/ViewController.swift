//
//  ViewController.swift
//  BullsEye
//
//  Created by cm on 15/12/21.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    var currentValue:Int = 50
    var targetValue:Int = 0
    var score = 0
    var round = 0

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, forState: .Normal)
        
        let hilightImageNormal = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(hilightImageNormal, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResize = trackLeftImage.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftResize, forState: .Normal)
        }
        
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            let trackRightResize = trackRightImage.resizableImageWithCapInsets(insets)
            slider.setMaximumTrackImage(trackRightResize, forState: .Normal)
        }
        
        
        startNewGame()
        updateTargetLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(sender: AnyObject) {
        let difference:Int = abs(currentValue - targetValue)
        var point = 100 - difference
        
        var title:String
        if difference == 0 {
            title = "Perfect"
            point += 100
        }else if difference < 5 {
            title = "You almost had it"
            if difference <= 1{
                point += 50
            }
        }else if difference < 10 {
            title = "Pretty good"
        }else{
            title = "Not even close..."
        }
        
        
        score += point
        
        let message = "You scored \(point) points"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: {action in
            self.startNewRound()
            self.updateTargetLabel()
        })
    }

    @IBAction func sliderMoved(sender: UISlider) {
        print("The slider value is: \(sender.value)")
        currentValue = lroundf(sender.value)
    }
    
    @IBAction func startOver(sender: UIButton) {
        startNewGame()
        updateTargetLabel()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.addAnimation(transition, forKey: nil)
        
    }
    
    func startNewGame(){
        score = 0
        round = 0
        startNewRound()
    }
    
    func startNewRound(){
        round += 1
        currentValue = 50
        targetValue = Int(1 + arc4random_uniform(100))
        slider.value = Float(currentValue)
    }
    
    func updateTargetLabel(){
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
}

