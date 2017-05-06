//
//  ViewController.swift
//  skoovymap
//
//  Created by Rock on 5/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var manager:CLLocationManager!
//    var my_position:UserAnnotation!
    var positions:Dictionary<String, UserAnnotation> = [:];
    var places:Dictionary<String, UserAnnotation> = [:]
    @IBOutlet weak var txt_search_content: UITextView!
    @IBOutlet weak var map: MKMapView!
    var ref = FIRDatabase.database().reference()
    var userlocation_ref:FIRDatabaseReference!;
    var postlocation_ref:FIRDatabaseReference!;
    override func viewDidLoad() {
        super.viewDidLoad()
        userlocation_ref = self.ref.child("userLocation")
        postlocation_ref = self.ref.child("posts")
        self.initLocationManager()
        self.initMapView()
        self.getAllUserLocation()
        self.getAllPlaceLocation()
    }
    
    func initMapView(){
        self.map.delegate = self
        self.map.mapType = MKMapType.standard
        self.map.showsUserLocation = false
        
    }

    func initLocationManager(){
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func getRandom() -> Int{
        
        let random = Int(arc4random());
        let value = random % 17
        return value + 1;
    }
    
    func getAllUserLocation(){
        
        //add listener
        userlocation_ref.observe(.childAdded, with: { (snapshot) -> Void in
            // user is me, then make my location avatar
            let key = FIRAuth.auth()?.currentUser?.uid;
            if(snapshot.key != key){
                let dic = snapshot.value as! NSDictionary
                let tmp_annotation = UserAnnotation()
                tmp_annotation.uid = snapshot.key
                tmp_annotation.avatar_index = 7
                tmp_annotation.is_user = true
                tmp_annotation.title = "uid"
                tmp_annotation.subtitle = snapshot.key
                let lat = dic["latitude"] as! NSNumber
                let lot = dic["longitude"] as! NSNumber
                let coordi = CLLocation(latitude: Double(lat), longitude: Double(lot))
                tmp_annotation.coordinate = coordi.coordinate
                self.map.addAnnotation(tmp_annotation)
                self.positions[snapshot.key] = tmp_annotation
            }
        });
        
        
        
        //delete listener
        userlocation_ref.observe(.childRemoved, with: { (snapshot) -> Void in
            let key_value = snapshot.key
            self.positions.removeValue(forKey: key_value)
        });
        
        
        //value change listener
        userlocation_ref.observe(.childChanged, with: { (snapshot) -> Void in
            let dic = snapshot.value as! NSDictionary
            let key_value = snapshot.key
            let lat = dic.value(forKey: "latitude")
            let lot = dic.value(forKey: "longitude")
            let coordinate = CLLocation(latitude: lat as! CLLocationDegrees, longitude: lot as! CLLocationDegrees)
            self.positions[key_value]?.coordinate = coordinate.coordinate
        });
    }
    
    func getAllPlaceLocation(){
        postlocation_ref.observe(.childAdded, with: { (snapshot) -> Void in
            // user is me, then make my location avatar
                let dic = snapshot.value as! NSDictionary
                let tmp_annotation = UserAnnotation()
                tmp_annotation.uid = snapshot.key
                tmp_annotation.count_posts = 1
                tmp_annotation.is_user = false
                let type = dic["postType"] as! String
            
                if(type.lowercased() == "event"){
                    tmp_annotation.avatar_index = 0
                }
                else if(type.lowercased()=="food"){
                    tmp_annotation.avatar_index = 1
                }
                else if(type.lowercased()=="place"){
                    tmp_annotation.avatar_index = 2
                }
                else if(type.lowercased() == "activity"){
                    tmp_annotation.avatar_index = 3
                }
            
                tmp_annotation.title = "uid"
                tmp_annotation.subtitle = snapshot.key
                let lat = dic["latitude"] as! NSNumber
                let lot = dic["longitude"] as! NSNumber
                let coordi = CLLocation(latitude: Double(lat), longitude: Double(lot))
                tmp_annotation.coordinate = coordi.coordinate
                self.map.addAnnotation(tmp_annotation)
                self.places[snapshot.key] = tmp_annotation
            
        });
        
        
        
        //delete listener
        postlocation_ref.observe(.childRemoved, with: { (snapshot) -> Void in
            let key_value = snapshot.key
            self.places.removeValue(forKey: key_value)
        });
        
        
        //value change listener
        postlocation_ref.observe(.childChanged, with: { (snapshot) -> Void in
            let dic = snapshot.value as! NSDictionary
            let key_value = snapshot.key
            let lat = dic.value(forKey: "latitude") as! NSNumber
            let lot = dic.value(forKey: "longitude") as! NSNumber
            let coordinate = CLLocation(latitude: Double(lat), longitude: Double(lot))
            self.places[key_value]?.coordinate = coordinate.coordinate
        });
    }
 
    /**
    **  Map kit annotation change
    **/
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation){
            return nil
        }
        let annotationIdentifier = "user_pin"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            //if is_user == true
            annotationView.canShowCallout = true
            let tmp_anno = annotation as! UserAnnotation
            annotationView.image = resizeImage(image: tmp_anno.imageView, newWidth: 40)
            
            if(tmp_anno.is_user == false){
                let nameLbl: UILabel! = UILabel(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
                nameLbl.textColor = UIColor.black
                nameLbl.textAlignment = .center
                nameLbl.text = "1"
                annotationView.addSubview(nameLbl)
            }
            
        }
        
        return annotationView
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width:newWidth, height:newHeight))
        image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        let str_coordinate = String.init(format: "%f %f", location.coordinate.latitude, location.coordinate.longitude)
        txt_search_content.text = str_coordinate
        let current_user = FIRAuth.auth()?.currentUser;
        let tmp_user : Any? = positions[(current_user?.uid)!]
        
        if (tmp_user == nil){
            let my_position = UserAnnotation()
            my_position.title = "Location";
            my_position.subtitle = "My Location";
            my_position.avatar_index = 1
            my_position.is_user = true
            my_position.uid = current_user?.uid
            my_position.coordinate = location.coordinate;
            map.addAnnotation(my_position)
            self.positions[(current_user?.uid)!] = my_position
        }
        
        self.positions[(current_user?.uid)!]?.coordinate = location.coordinate;
        self.UpdateUserPosition_Firebase(location: location);
    }
    
    func UpdateUserPosition_Firebase(location:CLLocation ){
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            self.ref.child("userLocation/\(user.uid)/latitude").setValue(location.coordinate.latitude)
            self.ref.child("userLocation/\(user.uid)/longitude").setValue(location.coordinate.longitude)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

