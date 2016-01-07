//
//  LocationCell.swift
//  MyLocations
//
//  Created by cm on 16/1/7.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForLocation(location:Location){
        if ((location.locationDescription?.isEmpty) == nil) {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        addressLabel.text = String(format: "Lat:%.8f, Long:%.8f", location.latitude, location.longitude)
    }

}
