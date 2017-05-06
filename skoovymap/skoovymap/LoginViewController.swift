//
//  LoginViewController.swift
//  skoovymap
//
//  Created by Rock on 5/5/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MBProgressHUD
class LoginViewController: UIViewController{
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBAction func OnClickLogin(_ sender: Any) {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        FIRAuth.auth()?.signIn(withEmail: txt_email.text!, password: txt_password.text!){ (user, error) in
            prog.hide(animated: true)
            if(error == nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "mapview")
                self.present(controller, animated: true, completion: nil)
            }
            else{
                print(error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
