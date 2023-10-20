//
//  locationManager.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/18.
//

import Foundation
import CoreLocation
import UIKit

class LocationTrackingManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationTrackingManager()
    private var locationManager = CLLocationManager()
    private var locationUpdateTimer: Timer?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func startTracking() {
        let authStatus = locationManager.authorizationStatus
        switch authStatus {
        case .notDetermined:
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            scheduleLocationUpdates()
        default:
            break
        }
    }
    
    func stopTracking() {
        locationUpdateTimer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    private func scheduleLocationUpdates() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .authorizedWhenInUse:
            changeLocationPermission()
        case .authorizedAlways:
            startTracking()
        default:
            break
        }
    }
    
    func changeLocationPermission() {
        let alertController = UIAlertController(title: "위치 권한 필요", message: "앱의 기능을 완전히 활용하려면 '항상 허용' 권한이 필요합니다. 설정으로 이동하시겠습니까?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        if let topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}

