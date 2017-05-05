//
//  ContentViewController.swift
//  skoovymap
//
//  Created by Sobura on 5/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.imgView.image = UIImage(named: "Teacher-and-Parents")
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
            return cell
        }

    }
    
}
