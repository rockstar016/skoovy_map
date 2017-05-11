//
//  NewContentRequestViewController.swift
//  skoovymap
//
//  Created by Sobura on 5/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewContentRequestViewController: UIViewController {
    
    var address : String = ""
    var lat : NSNumber = 0
    var long : NSNumber = 0
    
    
    @IBOutlet weak var addBtn: UIButton!
    private var embeddedViewController: RequestPostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RequestPostView, segue.identifier == "EmbedSegue" {
            

            vc.address = self.address
            vc.parentVC = self
            self.embeddedViewController = vc
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func onTapAddBtn(_ sender: Any)
    {
        embeddedViewController.compareStart_EndDate()
    }
    @IBAction func onTapCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func postRequestToFirebase() {
        
        
    }
    
}
