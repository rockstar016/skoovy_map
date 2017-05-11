//
//  ProfilePageViewController.swift
//  skoovymap
//
//  Created by Sobura on 5/11/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit


class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var listView : ProfileListView?
    var mapView : ProfileMapView?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        listView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileListView") as? ProfileListView
        mapView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileMapView") as? ProfileMapView
        self.containView.addSubview((listView?.view)!)
        listBtn.backgroundColor = UIColor.white
        mapBtn.backgroundColor = disableButtonColor
        
        pointsLabel.text = "3,200\npoints"
        postsLabel.text = "12\nposts"
        followersLabel.text = "232\nfollowers"
        followingLabel.text = "123\nfollowing"
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func onTapListBtn(_ sender: UIButton)
    {
        
        self.containView.addSubview((listView?.view)!)
        mapBtn.backgroundColor = disableButtonColor
        listBtn.backgroundColor = UIColor.white
    }
    
    @IBAction func onTapMapBtn(_ sender: UIButton)
    {
        
        self.containView.addSubview((mapView?.view)!)
        listBtn.backgroundColor = disableButtonColor
        mapBtn.backgroundColor = UIColor.white
    }
    
    @IBAction func onTapBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


