//
//  MapKitManager.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/18.
//

import UIKit
import MapKit
import CoreLocation

class MapKitManager: NSObject, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    private let regionDelta: Double = 0.05
    
    init(with mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        self.mapView.delegate = self
    }
    
    func moveToLocation(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.moveTo(coordinate: location, with: regionDelta)
    }
    
    func searchForLocation(searchText: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            guard let response = response, error == nil else {
                completion(nil)
                return
            }
            
            completion(response.boundingRegion.center)
        }
    }
    
    func getAddressFrom(coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            completion(placemark.name)
        }
    }
}

extension MKMapView {
    func moveTo(coordinate: CLLocationCoordinate2D, with delta: Double) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
        self.setRegion(region, animated: true)
    }
}
