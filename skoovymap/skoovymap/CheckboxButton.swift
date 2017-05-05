//
//  CheckButton.swift
//  skoovymap
//
//  Created by Sobura on 5/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//
import UIKit

struct Constants{
    struct AppColors{
        static let Gray_Color = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        static let White_Color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    struct ControlColor{
        static let Dark_Green_Color = UIColor(red: 165/255, green: 179/255, blue: 135/255, alpha:1.0)
        static let Green_Color = UIColor(red: 224/255, green: 236/255, blue: 99/255, alpha: 1.0)
    }
}

class CheckboxButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_box_white")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank_white")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
                self.tintColor = Constants.ControlColor.Dark_Green_Color
            } else {
                self.setImage(uncheckedImage, for: .normal)
                self.tintColor = Constants.ControlColor.Dark_Green_Color
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    func buttonClicked(_ sender:CheckboxButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }
}

