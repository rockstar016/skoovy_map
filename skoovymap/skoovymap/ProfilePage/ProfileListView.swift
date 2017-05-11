//
//  ProfileListView.swift
//  skoovymap
//
//  Created by Sobura on 5/11/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class ProfileListView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var parentVC : ProfilePageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileListViewCell", for: indexPath) as! ProfileListViewCell
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
}
