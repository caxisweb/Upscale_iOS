//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/16/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import MapKit

class StarbucksAnnotation: NSObject, MKAnnotation
{
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    var review : String!
    var rate : String!
    var hour : String!
    var user : String!
    var wifi : String!
    var call : String!
    var mail : String!
    var work : String!
    var km : String!
    var img : String!
    
    var id : String!
    var price : String!

    init(coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate
    }
}
