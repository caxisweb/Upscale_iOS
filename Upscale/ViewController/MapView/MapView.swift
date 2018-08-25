//
//  MapView.swift
//  Salontrip
//
//  Created by INFORAAM on 29/07/17.
//  Copyright © 2017 INFORAAM. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import Toaster

class MapView: UIViewController,GMSMapViewDelegate
{
    //MARK:- Ouutlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var mapView: GMSMapView!
    
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!

    
    
    var strLatitude = String()
    var strLongitude = String()

    var strSourceAddress = String()
    var strSourceCountry = String()

    var strDestinationAddress = String()
    var strDestinationCountry = String()

    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!

    
    
    var app = AppDelegate()
    var json : JSON!
    
    //MARK:-
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        app = UIApplication.shared.delegate as! AppDelegate

        if DeviceType.IS_IPHONE_X
        {
            self.viewNavigation.frame = CGRect(x:self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width:self.viewNavigation.frame.size.width, height:88)
            self.mapView.frame = CGRect(x:self.mapView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:self.mapView.frame.size.width, height:self.view.frame.size.height -  self.viewNavigation.frame.size.height)
        }
        
        self.mapView.delegate = self
        self.originCoordinate = CLLocationCoordinate2DMake(self.app.lat, self.app.long)
        self.destinationCoordinate = CLLocationCoordinate2DMake(Double(strLatitude)!, Double(strLongitude)!)
        
        if self.app.isConnectedToInternet()
        {
            self.drawPath()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }

    @IBAction func btnBack(_ sender: Any)
    {
        if let navControler = self.navigationController
        {
            navControler.popViewController(animated: true)
        }
    }
    
    
    func getRoutOfMap()
    {

//        originCoordinate = CLLocationCoordinate2D(latitude: Double(self.app.latitude), longitude: Double(self.app.latitude))
//        destinationCoordinate = CLLocationCoordinate2D(latitude: Double(strLatitude)!, longitude: Double(strLongitude)!)
        self.originCoordinate = CLLocationCoordinate2DMake(self.app.lat, self.app.long)
        self.destinationCoordinate = CLLocationCoordinate2DMake(Double(strLatitude)!, Double(strLongitude)!)
        
        // Source
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: CLLocationDegrees(self.app.lat), longitude: CLLocationDegrees(self.app.long)), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            

            if (placemarks?.count)! > 0
            {
                var placemark : CLPlacemark!
                placemark = placemarks?[0]
                if let formetAdd = placemark.addressDictionary!["FormattedAddressLines"] as? NSArray
                {
                    self.strSourceAddress = formetAdd.componentsJoined(by: ", ")
                }
                if let country = placemark.addressDictionary!["Country"] as? NSString
                {
                    self.strSourceCountry =  String(country)
                }
            }
            else
            {
                self.strSourceAddress = "Unknown Place"
            }
            
        })
                
        // Destination
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: CLLocationDegrees(self.strLatitude)!, longitude: CLLocationDegrees(self.strLongitude)!), completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                        return
                    }
                    
                    if (placemarks?.count)! > 0
                    {
                        var placemark : CLPlacemark!
                        placemark = placemarks?[0]
                        if let formetAdd = placemark.addressDictionary!["FormattedAddressLines"] as? NSArray
                        {
                            self.strDestinationAddress = formetAdd.componentsJoined(by: ", ")
                        }
                        if let country = placemark.addressDictionary!["Country"] as? NSString
                        {
                            self.strDestinationCountry =  String(country)
                        }
                    }
                    else
                    {
                        self.strDestinationAddress = "Unknown Place"
                    }
        })
        
        if self.app.isConnectedToInternet()
        {
            self.drawPath()
        }
        else
        {
            Toast(text: "Internet Connetion in not availble.Try Again").show()
        }
    }
    
    func drawPath()
    {
        let origin = "\(originCoordinate.latitude),\(originCoordinate.longitude)"
        let destination = "\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\("AIzaSyD-CTnHqDSgh-ICq35-45Pd0ck-37Q6q_g")"
        
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                self.json = try JSON(data: response.data!)
            } catch _ {
                self.json = nil
            }
//            self.json = JSON(data: response.data!)
            print(self.json)
            let routes = self.json["routes"].arrayValue
            
            self.mapView.camera = GMSCameraPosition.camera(withTarget: self.originCoordinate, zoom: 6.0)
            
            self.originMarker = GMSMarker(position: self.originCoordinate)
            self.originMarker.map = self.mapView
            self.originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
            self.originMarker.title = self.strSourceAddress
            
            self.destinationMarker = GMSMarker(position: self.destinationCoordinate)
            self.destinationMarker.map = self.mapView
            self.destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
            self.destinationMarker.title = self.strDestinationAddress

            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.routePolyline = GMSPolyline.init(path: path)
                self.routePolyline.strokeWidth = 4.0
                self.routePolyline.strokeColor = UIColor.blue
                
                self.routePolyline.map = self.mapView
            }
        }
    }
    
}
