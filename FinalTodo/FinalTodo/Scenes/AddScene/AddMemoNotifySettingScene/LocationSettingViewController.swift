//
//  LocationSettingViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/19.
//

import MapKit
import UIKit

class LocationSettingPageViewController: UIViewController, UISearchBarDelegate {
    
    private let topView = ModalTopView(title: "알림 설정")
    private let mapView = MKMapView()
    private let searchBar = UISearchBar()
    private let confirmButton = UIButton(type: .system)
    let viewModel = AddMemoPageViewModel()
    
    private var didInitialZoomToUserLocation = false
    private var mapManager: MapKitManager!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapManager()
    }
}

private extension LocationSettingPageViewController {
    // MARK: - SetUp
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        configureTopView()
        configureSearchBar()
        configureMapView()
        configureConfirmButton()
        setUpConstraints()
    }
    
    func configureTopView() {
        view.addSubview(topView)
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.barTintColor = .systemBackground
        searchBar.placeholder = "위치 검색"
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.setTitle("설정완료", for: .normal)
        confirmButton.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        confirmButton.backgroundColor = .secondarySystemBackground
        confirmButton.setTitleColor(.label, for: .normal)
        confirmButton.layer.cornerRadius = 10
    }
    
    func setUpConstraints() {
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(270)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }
    
    func setupMapManager() {
        mapManager = MapKitManager(with: mapView)
        LocationTrackingManager.shared.startTracking()
    }
}

extension LocationSettingPageViewController {
    // MARK: - Methods
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc func didTappedConfirmButton() {
        let centerCoordinate = mapView.centerCoordinate
        mapManager.getAddressFrom(coordinate: centerCoordinate) { [weak self] address in
            guard let address = address else { return }
            
            print("Selected Address: \(address)")
            self?.viewModel.locationNotifySetting = address
            
            let geofenceRadius: CLLocationDistance = 50
            print("모니터링을 시작합니다: \(centerCoordinate.latitude), \(centerCoordinate.longitude), 반경: \(geofenceRadius)미터")
            LocationTrackingManager.shared.startMonitoringGeofence(at: centerCoordinate, radius: geofenceRadius, identifier: "selectedGeofence")
            
            self?.dismiss(animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            mapManager.searchForLocation(searchText: searchText) { location in
                if let coordinate = location {
                    self.mapView.moveTo(coordinate: coordinate, with: 0.05)
                }
            }
        }
    }
}

