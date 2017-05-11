//
//  ShareLocationAlertView.swift
//  skoovymap
//
//  Created by Sobura on 5/9/17.
//  Copyright © 2017 Rock. All rights reserved.
//
import UIKit

protocol ShareLocationAlertViewDelegate:class {
    
    func createFromShareLocation() -> Void
    func requestFromShareLocation(address : String, lat : NSNumber, long : NSNumber) -> Void
    func shareLocationFromShareLocation() -> Void
}

class ShareLocationAlertView: UIView {
    
    weak var delegate : ShareLocationAlertViewDelegate?
    
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var shareLocationBtn: UIButton!
    
    var address : String = ""
    var lat : NSNumber?
    var long : NSNumber?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // appearance
        backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
    }
    
    @IBAction func onTapCreateBtn(_ sender: UIButton) {
        delegate?.createFromShareLocation()
    }
    
    @IBAction func onTapRequestBtn(_ sender: UIButton) {
        print("ddd")
        delegate?.requestFromShareLocation(address: address, lat: lat!, long: long!)
    }
    @IBAction func onTapShareLocationBtn(_ sender: UIButton) {
        delegate?.shareLocationFromShareLocation()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = createBtn.hitTest(convert(point, to: createBtn), with: event) {
            return result
        }
        if let result = requestBtn.hitTest(convert(point, to: requestBtn), with: event) {
            return result
        }
        if let result = shareLocationBtn.hitTest(convert(point, to: shareLocationBtn), with: event) {
            return result
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
    
}
