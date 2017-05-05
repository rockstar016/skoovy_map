//
//  VideoCell.swift
//  skoovymap
//
//  Created by Sobura on 5/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit
import MobilePlayer
import AVFoundation

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        videoPreviewUiimage()
        let path = Bundle.main.path(forResource: "splash", ofType: "mp4")!
        print(path)
        let videoURL = URL.init(fileURLWithPath: path)
        let playerVC = MobilePlayerViewController.init(contentURL: videoURL as URL)
        playerVC.stop()
        playerVC.activityItems = [videoURL] // Check the documentation for more information.
        
        playerVC.view.frame = videoView.frame
        videoView.addSubview(playerVC.view)

    }
    func videoPreviewUiimage() {
        let path = Bundle.main.path(forResource: "splash", ofType: "mp4")!
        print(path)
        let videoURL = URL.init(fileURLWithPath: path)
        
        let asset = AVURLAsset(url: videoURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            imgView.image =  UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
        }
    }

}
