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
import MobileCoreServices

let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ShareLocationAlertViewDelegate, UserLocationViewDelegate, UIGestureRecognizerDelegate, MyAnnotationViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var manager:CLLocationManager!
//    var my_position:UserAnnotation!
    var positions:Dictionary<String, UserAnnotation> = [:];
    var places:Dictionary<String, UserAnnotation> = [:]
    var newMedia : Bool = false
    var imgdata : Data!
    var businessImage:UIImage!
    let spacer = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n"
    var imageView = UIImageView(frame: CGRect( x: 10,y: 50,width: 250,height: 250))
    
    @IBOutlet weak var txt_search_content: UITextView!
    //@IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var map: MKMapView!
    
    var ref = FIRDatabase.database().reference()
    var userlocation_ref:FIRDatabaseReference!;
    var postlocation_ref:FIRDatabaseReference!;
    
    
    var selectedNewAnnotation:MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapTapGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapTapGesture.delegate = self
        
        map.addGestureRecognizer(mapTapGesture)
        userlocation_ref = self.ref.child("userLocation")
        postlocation_ref = self.ref.child("posts")
        self.initLocationManager()
        self.initMapView()
        self.getAllUserLocation()
        self.getAllPlaceLocation()
        
    }
    
    func handleMapTap(_ sender:UILongPressGestureRecognizer)
    {
        let tapLocation = sender.location(in: map)
        let coordinate = map.convert(tapLocation, toCoordinateFrom: map)
        
        print("lat = \(coordinate.latitude)")
        print("long = \(coordinate.longitude)")
        
        let tmp_annotation = UserAnnotation()
        //tmp_annotation.uid = snapshot.key
        tmp_annotation.avatar_index = 7
        tmp_annotation.is_user = true
        tmp_annotation.title = "uid"
        //tmp_annotation.subtitle = snapshot.key
        let lat = coordinate.latitude
        let lot = coordinate.longitude
        let coordi = CLLocation(latitude: Double(lat), longitude: Double(lot))
        tmp_annotation.coordinate = coordi.coordinate
        tmp_annotation.isNew = true
        self.map.addAnnotation(tmp_annotation)
        self.selectedNewAnnotation = tmp_annotation
        map.selectAnnotation(tmp_annotation, animated: false)
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
 
    func diddeselected(target: MKAnnotation) {
        self.map.removeAnnotation(self.selectedNewAnnotation!)
    }
    /**
    **  Map kit annotation change
    **/
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation){
            return nil
        }
        
        let annotationIdentifier = "user_pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = UserAnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            (annotationView as! UserAnotationView).userlocationdetaildelegate = self
            (annotationView as! UserAnotationView).sharelocationdetaildelegate = self
            (annotationView as! UserAnotationView).myannotationdelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            let tmp_anno = annotation as! UserAnnotation
            
            annotationView.image = resizeImage(image: tmp_anno.imageView, newWidth: 40)
            (annotationView as! UserAnotationView).Parsing(annotation: tmp_anno)
            (annotationView as! UserAnotationView).setParent(vc: self)
            
            if(tmp_anno.is_user == false){
                let nameLbl: UILabel! = UILabel(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
                nameLbl.textColor = UIColor.black
                nameLbl.textAlignment = .center
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
    
    func NextFromUserLocation() {
        print("OK")
    }

    
    func requestFromShareLocation(address: String, lat: NSNumber, long: NSNumber) {
        
        
        let controller = mainstoryboard.instantiateViewController(withIdentifier: "RequestView") as! NewContentRequestViewController
        

        controller.address = address
        controller.lat = lat
        controller.long = long
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func createFromShareLocation() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true,
                         completion: nil)
            self.newMedia = true
        }

    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image:UIImage! = info[UIImagePickerControllerEditedImage]
                as! UIImage
            imageView.image = image
            imgdata = UIImageJPEGRepresentation(image, 0.8)
            self.businessImage = UIImage(data: imgdata!)
        }
        imageAlret()
        print("sssssss")
    }
    
    func imageAlret()
    {
        let alertMessage = UIAlertController(title: "Use Photo ?", message: spacer, preferredStyle: .alert)
        
        let showImageView = UIImageView(frame: CGRect(x: 10,y: 50,width: 250,height: 250))
        showImageView.image = UIImage(data: self.imgdata)
        let UsePhotoAction = UIAlertAction(title: "Use Photo", style: .default, handler: nil)
        let CancelPhotoAction = UIAlertAction(title: "CanCel", style: .default, handler: nil)
        
        alertMessage.addAction(UsePhotoAction)
        alertMessage.addAction(CancelPhotoAction)
        alertMessage.view.addSubview(showImageView)
        
        present(alertMessage, animated: true, completion: nil)
    }

    func shareLocationFromShareLocation() {
        print("sfsf")
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
 //       mapView.removeAnnotation(view.annotation!)
    }
    @IBAction func onTapProfileBtn(_ sender: Any) {
        
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "ProfilePageViewController") as! ProfilePageViewController
        self.present(vc, animated: true, completion: nil)
    }
}

