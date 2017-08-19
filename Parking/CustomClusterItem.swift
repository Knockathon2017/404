//
//  CustomCluster.swift
//  Parking
//
//  Created by Gaurav on 19/08/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import Foundation




// Clustering markers customization

class CustomClusterItem: NSObject, GMUClusterItem {
    
    var position: CLLocationCoordinate2D
    
    var type: MarkerType
    
    var icon: UIImage
    
    
    
    init(position: CLLocationCoordinate2D, type: MarkerType, icon: UIImage)
    {
        
        self.position = position
        
        self.type = type
        
        self.icon = icon
        
    }
    //MARK: - GMUClusterRendererDelegate
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker:
        GMSMarker) {
        
        if (marker.userData! is CustomClusterItem) {
            
            let customClusterItem = (marker.userData! as! CustomClusterItem)
            
            
            
            switch customClusterItem.type {
                
            case MarkerType.RegularMarker:
                
                marker.icon = UIImage(named: "household")
                
                break
                
            case MarkerType.LandmarkMarker:
                
                marker.icon = UIImage(named: "all")
                
                break
                
            case MarkerType.GovernmentMarker:
                
                marker.icon = UIImage(named: "office")
                
                break
                
            }
            
        }
    }
        
}
