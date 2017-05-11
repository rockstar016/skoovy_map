//
//  ProfileListViewCell.swift
//  skoovymap
//
//  Created by Sobura on 5/11/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit

class ProfileListViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func prepareForReuse() {
        addressLabel.text = ""
        stateImageView.image = UIImage(named: "download")
        monthLabel.text = "Jan"
        dateLabel.text = "8"
        durationLabel.text = ""
        questionLabel.text = ""
    }
}
