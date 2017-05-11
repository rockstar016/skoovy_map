//
//  ReceiveRequestView.swift
//  skoovymap
//
//  Created by Sobura on 5/9/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

protocol ReceiveRequestViewDelegate:class {
    
    func NextFromReceiveRequest() -> Void
}

class ReceiveRequestView: UIView {
    
    weak var delegate : ReceiveRequestViewDelegate?
    
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var receiveRequestLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // appearance
        backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
    }
    
    @IBAction func onTapNextBtn(_ sender: UIButton) {
        delegate?.NextFromReceiveRequest()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = nextBtn.hitTest(convert(point, to: nextBtn), with: event) {
            return result
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
    
}
