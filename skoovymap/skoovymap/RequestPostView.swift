//
//  requestPostView.swift
//  skoovymap
//
//  Created by Sobura on 5/9/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit
import DatePickerDialog

let disableColor = UIColor(colorLiteralRed: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
let disableButtonColor = UIColor(colorLiteralRed: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
let contentTextColor = UIColor(colorLiteralRed: 255/255, green: 120/255, blue: 18/255, alpha: 1.0)

class RequestPostView: UITableViewController, UITextViewDelegate {
    
    var startDate : Date?
    var endDate : Date?
    var address : String?
    var checkedState : String = ""
    var parentVC : NewContentRequestViewController?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var endTimeBtn: UIButton!
    @IBOutlet weak var startTimeBtn: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet var typeCheckArray: [CheckboxButton]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        contentTextView.text = "Placeholder text here..."
        contentTextView.textColor = contentTextColor
        timeSwitch.isOn = false
        unCheckAll()

        addressTextField.text = self.address
        
    }
    
    @IBAction func onClickTypeCheck(_ sender: CheckboxButton)
    {
        unCheckAll();
        sender.isChecked = true
        
        switch sender.tag {
        case 1:
            checkedState = "Food"
            break
        case 2:
            checkedState = "Event"
            break
        case 3:
            checkedState = "Business"
            break
        case 4:
            checkedState = "Other"
            break
        default:
            break
        }
        addBtnState()
    }
    
    func unCheckAll()
    {
        typeCheckArray[0].isChecked = false
        typeCheckArray[1].isChecked = false
        typeCheckArray[2].isChecked = false
        typeCheckArray[3].isChecked = false
    }
    
    @IBAction func editTitleTextField(_ sender: Any)
    {
        addBtnState()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Placeholder text here..." {
            
            textView.text = ""
            textView.textColor = contentTextColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        addBtnState()
    }
    @IBAction func onTapTimeSwitch(_ sender: Any) {
       
        let switchStatus = timeSwitch.isOn
        
        if switchStatus
        {
            startTimeBtn.isUserInteractionEnabled = false
            endTimeBtn.isUserInteractionEnabled = false
            startTimeBtn.setTitleColor(disableColor, for: .normal)
            endTimeBtn.setTitleColor(disableColor, for: .normal)
            startDateLabel.text = ""
            endDateLabel.text = ""
            
        }
        else
        {
            startTimeBtn.isUserInteractionEnabled = true
            endTimeBtn.isUserInteractionEnabled = true
            startTimeBtn.setTitleColor(UIColor.black, for: .normal)
            endTimeBtn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onTapStartTime(_ sender: UIButton) {
        DatePickerDialog().show(title: "StartTime", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), datePickerMode: .date)
        {(date)->Void in
            
            if date == nil
            {
                return
            }
            self.startDate = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy  hh:mm a"
            let dateString = dateFormatter.string(from: date!)
            self.startDateLabel.text = dateString
        }
    }
    
    @IBAction func onTapEndTime(_ sender: UIButton) {
        DatePickerDialog().show(title: "EndTime", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), datePickerMode: .date)
        {(date)->Void in
            
            if date == nil
            {
                return
            }
            self.endDate = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy  hh:mm a"
            let dateString = dateFormatter.string(from: date!)
            self.endDateLabel.text = dateString
        }
    }
    
    func compareStart_EndDate()
    {
        if endDateLabel.text != "" && startDateLabel.text != "" {
            
            if startDate! == endDate! || startDate! > endDate! {
                Skoovymap_Alamofire.displayError("Please input startdate and Enddate correctly.")
            }
        }
    }
    
    func addBtnState()
    {
        if titleTextField.text != "" && contentTextView.text != "" && checkedState != ""{
            
            parentVC?.addBtn.isEnabled = true
            parentVC?.addBtn.setTitleColor(UIColor.black, for: .normal)
            
        }
        else
        {
            parentVC?.addBtn.isEnabled = false
            parentVC?.addBtn.setTitleColor(disableColor, for: .normal)
        }
    }
}
