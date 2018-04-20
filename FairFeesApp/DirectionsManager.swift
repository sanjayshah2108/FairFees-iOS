//
//  DirectionsManager.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-15.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class DirectionsManager: NSObject {
    
    static let theDirectionsManager = DirectionsManager()
    
    var mapView: GMSMapView!
    var distanceLabel: UILabel!
    var activePolylines: [GMSPolyline]!
    var polylineToShow: GMSPolyline!
    
    //get the midpoint between our location and the listing, so we can centralize the map around that
    func getMidpoint(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1 = sourceCoordinate.longitude * .pi / 180
        let lon2 = destinationCoordinate.longitude * .pi / 180
        let lat1 = sourceCoordinate.latitude * .pi / 180
        let lat2 = destinationCoordinate.latitude * .pi / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / .pi, lon3 * 180 / .pi)
        
        return center
    }
    
    
    func getPolylineRoute(from source: CLLocation, to destination: CLLocation){
       
        let sourceCoordinate = source.coordinate
        let destinationCoordinate = destination.coordinate
        
        let distance = destination.distance(from: source)
        let midPointCoordinate = getMidpoint(sourceCoordinate: sourceCoordinate, destinationCoordinate: destinationCoordinate)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceCoordinate.latitude),\(sourceCoordinate.longitude)&destination=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&sensor=true&mode=driving&key=AIzaSyDT14Cef5MjsDIc70mQPh4ToyJnltmEGPA")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                
                //How should we handle this error?
                print(error!.localizedDescription)
                //topController.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                
                                //produce an alert?
                                //topController.activityIndicator.stopAnimating()
                            }
                            return
                        }
                        
                        //if there are directions available
                        if (routes.count > 0) {
                            
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            
                            let points = dictPolyline?.object(forKey: "points") as? String
                            
                            self.showPath(polyStr: points!)
                            
                            self.getPathDistance(from: source, to: destination) { (distance) in
                                
                                //Update UI on main thread
                                DispatchQueue.main.async {
                                    self.distanceLabel.text = distance
                                }
                            }
                      
                            //Update UI on main thread
                            DispatchQueue.main.async {
                                
                                //topController.activityIndicator.stopAnimating()
                                
                                //centralizeMap
                                let update = GMSCameraUpdate.setTarget(midPointCoordinate, zoom: 11)
                                self.mapView.animate(with: update)
                            }
                        }
                            
                        //else if no directions available
                        else {
                            DispatchQueue.main.async {
                                //produce an alert?
                                //topController.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        //produce an alert?
                        //topController.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 1.0

        polyline.strokeColor = UIColor.blue
        polyline.map = mapView
        polylineToShow = polyline
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "polylineAddedKey"), object: nil)
    }
    
    func removePath(){
        polylineToShow.map = nil
    }
    
    func getPathDistance(from source: CLLocation, to destination: CLLocation, completion: @escaping(String) -> Void) {
            
        var dist = ""
        
        let sourceCoordinate = source.coordinate
        let destinationCoordinate = destination.coordinate
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceCoordinate.latitude),\(sourceCoordinate.longitude)&destination=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&sensor=true&mode=driving&key=AIzaSyDT14Cef5MjsDIc70mQPh4ToyJnltmEGPA")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                completion(dist)
                return
            }
            if let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any],
                let routes = result["routes"] as? [[String:Any]], let route = routes.first,
                let legs = route["legs"] as? [[String:Any]], let leg = legs.first,
                let distance = leg["distance"] as? [String:Any], let distanceText = distance["text"] as? String {
                dist = distanceText
                
                }
                completion(dist)
            })
            task.resume()
    }

}
