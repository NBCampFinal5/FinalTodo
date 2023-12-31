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
    
    func startMonitoringGeofence(at coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let geofenceRegion = CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)
            geofenceRegion.notifyOnEntry = true
            geofenceRegion.notifyOnExit = false
            
            print("지오펜스 모니터링을 시작합니다")
            locationManager.startMonitoring(for: geofenceRegion)
        } else {
            print("지오펜스 모니터링을 사용할 수 없습니다.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("지오펜스 영역에 진입했습니다: \(region.identifier)")
            sendNotification(title: "위치 도착 알림", body: "메모에 설정한 위치에 도착했습니다.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            //                locationManager.stopUpdatingLocation()
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
        if locationManager.authorizationStatus != .authorizedAlways {
            let alertController = UIAlertController(
                title: "위치 권한 제한됨",
                message: "앱의 온전한 기능을 사용하려면 위치 서비스 권한이 필요합니다. '항상 허용'으로 설정하면 앱의 기능을 최대한 활용할 수 있습니다.",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            if let topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "geofence", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

