//
//  HudView.swift
//  MyLocations
//
//  Created by yaoyingtao on 16/1/1.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit

class HudView: UIView {
    
    var text = ""
    
    class func hudInView(view:UIView, animated:Bool)->HudView{
        let hud = HudView(frame: view.bounds)
        hud.backgroundColor = UIColor.clearColor()
        view.userInteractionEnabled = false
        view.addSubview(hud)
        
        hud.showAnimation(animated)
        return hud
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let boxWidth:CGFloat = 96
        let boxHeight:CGFloat = 96
        
        let rect = CGRect(x: round((bounds.width - boxWidth)/2), y: round((bounds.height - boxHeight)/2), width: boxWidth, height: boxHeight)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        path.fill()
        
        if let checkImage = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(x: round(center.x - checkImage.size.width / 2), y: round(center.y - checkImage.size.height / 2 - boxHeight / 8))
            
            checkImage.drawAtPoint(imagePoint)
        }
        
        let textDic = [NSFontAttributeName:UIFont.systemFontOfSize(16) , NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let textSize = text.sizeWithAttributes(textDic)
        let textPoint = CGPoint(x: round(center.x - textSize.width / 2), y: center.y - textSize.height / 2 + boxHeight / 4)
        text.drawAtPoint(textPoint,withAttributes: textDic)
    }
    
    func showAnimation(animated:Bool){
        if animated {
            alpha = 0
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
                self.alpha = 1
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
            
        }
    }
    

}
