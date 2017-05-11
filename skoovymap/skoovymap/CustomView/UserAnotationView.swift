//
//  UserAnotationView.swift
//  skoovymap
//
//  Created by Sobura on 5/9/17.
//  Copyright © 2017 Rock. All rights reserved.
//

//
//  PersonWishListAnnotationView.swift
//  CustomPinsMap
//
//  Created by Ignacio Nieto Carvajal on 6/12/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import MapKit

protocol MyAnnotationViewDelegate:class {
    func diddeselected(target:MKAnnotation)->Void
}


//private let kPersonMapPinImage = UIImage(named: "mapPin")!
private let kPersonMapAnimationTime = 0.300

class UserAnotationView: MKAnnotationView {
    // data
    weak var userlocationdetaildelegate: UserLocationViewDelegate?
    weak var sharelocationdetaildelegate: ShareLocationAlertViewDelegate?
    
    weak var myannotationdelegate: MyAnnotationViewDelegate?
    
    weak var customCalloutView: UserLocationView?
    weak var customCalloutView1: ShareLocationAlertView?
    var isUser:Bool = false
    var uid:String?
    var lat:NSNumber?
    var long:NSNumber?
    var address:String? = ""
    var parent:MapViewController?
    var isNew:Bool = false
    
    override var annotation: MKAnnotation? {
        willSet
        {
            customCalloutView?.removeFromSuperview()
            customCalloutView1?.removeFromSuperview()
        }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
  //      self.image = kPersonMapPinImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // This is important: Don't show default callout.
  //      self.image = kPersonMapPinImage
    }
    
    func Parsing(annotation:UserAnnotation)
    {
        self.isUser = annotation.is_user
        self.uid = annotation.uid
        self.lat = annotation.coordinate.latitude as NSNumber?
        self.long = annotation.coordinate.longitude as NSNumber?
        self.isNew = annotation.isNew
        self.address = annotation.address
    }
    
    func setParent(vc:MapViewController)
    {
        self.parent = vc
    }
    
    // MARK: - callout showing and hiding
    // Important: the selected state of the annotation view controls when the
    // view must be shown or not. We should show it when selected and hide it
    // when de-selected.
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            self.customCalloutView1?.removeFromSuperview()
           
            fromCoordinatesToAddress(lat: Float(lat!), long: Float(long!))

            if(self.isUser == false)
            {
                if let newCustomCalloutView = loadUserLocationView(){
                    // fix location from top-left to its right place.
                    newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                    newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                    
                    // set custom callout view
                    self.addSubview(newCustomCalloutView)
                    self.customCalloutView = newCustomCalloutView

                    // animate presentation
                    if animated {
                        self.customCalloutView!.alpha = 0.0
                        UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                            self.customCalloutView!.alpha = 1.0
                        })
                    }
                }
            }
            else
            {
                if let newCustomCalloutView1 = loadShareLocationView(){
                    // fix location from top-left to its right place.
                    newCustomCalloutView1.frame.origin.x -= newCustomCalloutView1.frame.width / 2.0 - (self.frame.width / 2.0)
                    newCustomCalloutView1.frame.origin.y -= newCustomCalloutView1.frame.height
                    
                    // set custom callout view
                    self.addSubview(newCustomCalloutView1)
                    self.customCalloutView1 = newCustomCalloutView1
                    self.customCalloutView1?.contentLabel.text = address
                    self.customCalloutView1?.address = address!
                    self.customCalloutView1?.lat = lat
                    self.customCalloutView1?.long = long
                    
                    // animate presentation
                    if animated {
                        self.customCalloutView1!.alpha = 0.0
                        UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                            self.customCalloutView1!.alpha = 1.0
                        })
                    }
                    
                }
            }
        } else {
            if customCalloutView != nil {
                //self.customCalloutView!.removeFromSuperview()
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                }
                else
                {
                    self.customCalloutView!.removeFromSuperview()
                } // just remove it.
            }
            
            if customCalloutView1 != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView1!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView1!.removeFromSuperview()
                    })
                } else { self.customCalloutView1!.removeFromSuperview() } // just remove it.
                //self.customCalloutView1!.removeFromSuperview()
            }
            self.parent?.txt_search_content.text = ""
            
            if(self.isNew)
            {
                //self.isHidden = true
                self.removeFromSuperview()
//                self.parent?.map.removeAnnotation(self.annotation!)
                //self.parent?.map.removeAnnotation(self.annotation!)
            }
        }
    }

        // lat, long -> Address
    func fromCoordinatesToAddress(lat : Float, long : Float)
    {
        let latitude = String(lat)
        let longitude = String(long)
        
        Skoovymap_Alamofire.GET2(GOOGLE_API + latitude + "," + longitude, parameters: [:], showLoading: false, showSuccess: true, showError: true)
        { (result, responseObject)
            in
            if(result)
            {
                let result = responseObject.object(forKey: "results") as! [NSDictionary]
                let address = result[0]
                let addresscomf = address.object(forKey: "address_components") as! [NSDictionary]
                
                let post = addresscomf[0] as NSDictionary
                let postcode = post.object(forKey: "long_name") as! String
                self.address = postcode
                self.parent?.txt_search_content.text = postcode
                if self.customCalloutView1 != nil {
                    self.customCalloutView1?.contentLabel.text = self.address
                    self.customCalloutView1?.address = self.address!
                    self.customCalloutView1?.lat = self.lat
                    self.customCalloutView1?.long = self.long
                }
            }
        }
    }
    
    func loadShareLocationView()->ShareLocationAlertView?
    {
        if let views = Bundle.main.loadNibNamed("ShareLocationAlertView", owner: self, options: nil) as? [ShareLocationAlertView], views.count > 0 {
            let sharelocationview = views.first!
            sharelocationview.delegate = self.sharelocationdetaildelegate
            if let personAnnotation = annotation as? UserAnnotation {
                //Vlue
                //let person = personAnnotation.person
                //personDetailMapView.configureWithPerson(person: person)
            }
            return sharelocationview
        }
        return nil
    }
    
    func loadUserLocationView() -> UserLocationView? {
        if let views = Bundle.main.loadNibNamed("UserLocationView", owner: self, options: nil) as? [UserLocationView], views.count > 0 {
            let userlocationview = views.first!
            userlocationview.delegate = self.userlocationdetaildelegate
            if let personAnnotation = annotation as? UserAnnotation {
                //Vlue
                //let person = personAnnotation.person
                //personDetailMapView.configureWithPerson(person: person)
            }
            return userlocationview
        }
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
        self.customCalloutView1?.removeFromSuperview()
    }
    
    // MARK: - Detecting and reaction to taps on custom callout.
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if (customCalloutView != nil)
            {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            }
            else if (customCalloutView1 != nil)
            {
                return customCalloutView1!.hitTest(convert(point, to: customCalloutView1!), with: event)
            }
            else
            {
                return nil
            }
        }
    }
}
