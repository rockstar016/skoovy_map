//
//  Skoovymap_Alamofire.swift
//  skoovymap
//
//  Created by Sobura on 5/10/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD
import NVActivityIndicatorView

var spiningActivity:MBProgressHUD?=nil

var loadingView:UIView = UIView()
var loadingAcitivity:NVActivityIndicatorView?=nil
var curviewcontroller:UIViewController?=nil
let KEYWINDOW = UIApplication.shared.keyWindow

class Skoovymap_Alamofire: SessionManager {
    
    struct Static {
        static var instance: Skoovymap_Alamofire? = nil
        static var token: Int = 0
    }
    
    private static var __once: () = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 60.0
        //                configuration.URLCache?.removeAllCachedResponses()
        let manager = Skoovymap_Alamofire(configuration: configuration)
        Static.instance = manager
        //                Static.instance?.session.configuration.timeoutIntervalForRequest = 30.0
        //                Static.instance?.session.configuration.timeoutIntervalForResource = 60.0
        //                Static.instance?.session.configuration.URLCache?.removeAllCachedResponses()
    }()
    
    static var spiningShowed:Bool = false
    
    class var shareInstance: Skoovymap_Alamofire {
        get {
            //            struct Static {
            //                static var instance: FHAlamofire? = nil
            //                static var token: Int = 0
            //            }
            _ = Skoovymap_Alamofire.__once
            return Static.instance!
        }
    }
    
    
    class func DELETE(_ url:String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, completionHandler: @escaping (_ result:Bool,_ responseObject:NSDictionary) -> Void) -> Request {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            //            "Authorization": "Bearer " + UserDefaults.getUserToken()
        ]
        
        return Skoovymap_Alamofire.shareInstance.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON{ response in
            //        return FHAlamofire.shareInstance.request(.DELETE, url, parameters: parameters, headers: headers).validate().responseJSON{ response in
            switch response.result {
            case .success(let JSON):
                
                let res = JSON as! NSDictionary
                print(res)
                if let ok = res["ok"] as? Bool {
                    if ok{
                        if res["message"] != nil && showSuccess{
                            self.displaySuccess(res["message"] as? String ?? "")
                        }
                        completionHandler( true,res)
                    }else{
                        if res["message"] != nil && showError{
                            self.displayError(res["message"] as! String)
                        }
                        completionHandler( false,res)
                    }
                }
                
            case .failure(let error):
                print(error)
                switch response.response!.statusCode {
                case -1005:
                    self.displayError(error.localizedDescription)
                    break
                default:
                    break
                }
                completionHandler( false,[:])
            }
            hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class  func POST(_ url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, completionHandler: @escaping (_ result:Bool,_ responseObject:NSDictionary) -> Void) -> Request {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if showLoading {
            showIndicator()
        }
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            //            "Authorization": "Bearer " + FHUserDefaults.getUserToken()
        ]
        

        return Skoovymap_Alamofire.shareInstance.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON{ response in
            //        return FHAlamofire.shareInstance.request(.POST, url, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                
                let res = JSON as! NSDictionary
                
                if let ok = res["result"] as? Bool {
                    if ok {
                        if res["message"] != nil && showSuccess {
                            self.displaySuccess(res["message"] as? String ?? "")
                        }
                        completionHandler( true,res)
                    }else{
                        if res["message"] != nil && showError {
                            self.displayError(res["message"] as! String)
                        }
                        completionHandler(false, res)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler( false,[:])
            }
            hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    class func GET(_ url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, completionHandler: @escaping (_ result:Bool,_ responseObject:NSDictionary) -> Void) -> Request {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if showLoading {
            showIndicator()
        }
        return Skoovymap_Alamofire.shareInstance.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON{ response in
            
            //        return FHAlamofire.shareInstance.request(.GET, url, parameters: parameters)
            //            .validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let res = JSON as! NSDictionary
                if let ok = res["result"] as? Bool {
                    if ok{
                        if res["message"] != nil && showSuccess{
                            self.displaySuccess(res["message"] as? String ?? "")
                        }
                        completionHandler( true,res)
                    }else{
                        if res["message"] != nil && showError{
                            self.displayError(res["message"] as! String)
                        }
                        completionHandler( false,res)
                    }
                }
                
            case .failure(let error):
                print(error)
                switch response.response!.statusCode {
                case -1005:
                    self.displayError(error.localizedDescription)
                    break
                default:
                    break
                }
                completionHandler( false,[:])
            }
            hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    class func GET2(_ url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, completionHandler: @escaping (_ result:Bool,_ responseObject:AnyObject) -> Void) -> Request {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print(url)
        if showLoading {
            showIndicator()
        }
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            //            "Authorization": "Bearer " + FHUserDefaults.getUserToken()
        ]
        print(headers)
        return Skoovymap_Alamofire.shareInstance.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON{ response in
            //        return FHAlamofire.shareInstance.request(.GET, url, parameters: parameters, headers:headers)
            //            .validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionHandler( true,JSON as AnyObject)
            case .failure(let error):
                print(error)
                
                completionHandler( false,[] as AnyObject)
            }
            hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func displaySuccess(_ message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Success", message:message, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        KEYWINDOW?.topMostController()?.present(myAlert, animated: true, completion: nil)
    }
    
    class func displayError(_ message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        KEYWINDOW?.topMostController()?.present(myAlert, animated: true, completion: nil)
    }
    
    class  func showIndicator(_ vc:UIViewController)
    {
        curviewcontroller = vc
        
        let curframe = curviewcontroller?.view.frame
        
        loadingView = UIView(frame: (curviewcontroller?.view.frame)!)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        loadingAcitivity = NVActivityIndicatorView(frame: CGRect(x: (curframe?.width)!/2 - 30, y: (curframe?.height)!/2-30, width: 60, height: 60), type: .ballScale, color: self.UIColorFromHex(0xEC644B), padding: CGFloat(0))
        loadingAcitivity!.startAnimating()
        loadingView.addSubview(loadingAcitivity!)
        
        vc.view.isUserInteractionEnabled = false
        
        if loadingView.superview == nil{
            vc.view.addSubview(loadingView)
        }
    }
    
    /*class func hideIndicator(vc:UIViewController){
     loadingAcitivity!.stopAnimation()
     vc.view.userInteractionEnabled = true
     
     if loadingView.superview != nil{
     loadingView.removeFromSuperview()
     }
     }*/
    
    class  func showIndicator() {
        curviewcontroller = KEYWINDOW?.topMostController()
        let curframe = curviewcontroller?.view.frame
        
        loadingView = UIView(frame: (curviewcontroller?.view.frame)!)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        loadingAcitivity = NVActivityIndicatorView(frame: CGRect(x: (curframe?.width)!/2 - 30, y: (curframe?.height)!/2-30, width: 60, height: 60), type: .ballScale, color: self.UIColorFromHex(0xEC644B), padding: CGFloat(0))
        loadingAcitivity!.startAnimating()
        loadingView.addSubview(loadingAcitivity!)
        
        KEYWINDOW?.isUserInteractionEnabled = false
        
        if loadingView.superview == nil{
            KEYWINDOW?.topMostController()?.view.addSubview(loadingView)
        }
    }
    
    class func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func hideIndicator(){
        if loadingView.superview != nil{
            loadingAcitivity!.stopAnimating()
            KEYWINDOW?.isUserInteractionEnabled = true
            loadingView.removeFromSuperview()
        }
    }
}

