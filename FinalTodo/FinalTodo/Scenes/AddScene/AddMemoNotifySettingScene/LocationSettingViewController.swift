//
//  LocationSettingViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/19.
//

import MapKit
import UIKit

class LocationSettingPageViewController: UIViewController, UISearchBarDelegate {
    
    weak var delegate: LocationSettingDelegate?
    private let topView = ModalTopView(title: "알림 설정")
    private let mapView = MKMapView()
    private let searchBar = UISearchBar()
    private let confirmButton = UIButton(type: .system)
    let viewModel: AddMemoPageViewModel
    var handler: () -> Void = {}
    
    init(viewModel: AddMemoPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var didInitialZoomToUserLocation = false
    private var mapManager: MapKitManager!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        handler()
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
        confirmButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        confirmButton.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        confirmButton.backgroundColor = .secondarySystemBackground
        confirmButton.setTitleColor(.label, for: .normal)
        confirmButton.layer.cornerRadius = 5
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
            make.top.equalTo(mapView.snp.bottom).offset(30)
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
            self?.delegate?.didCompleteLocationSetting(location: address)
            self?.viewModel.optionImageAry[1] = address
            
            let geofenceRadius: CLLocationDistance = 50
            print("모니터링을 시작합니다: \(centerCoordinate.latitude), \(centerCoordinate.longitude), 반경: \(geofenceRadius)미터")
            LocationTrackingManager.shared.startMonitoringGeofence(at: centerCoordinate, radius: geofenceRadius, identifier: "selectedGeofence")
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            mapManager.searchForLocation(searchText: searchText) { [weak self] location in
                guard let self = self, let coordinate = location else { return }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.mapView.addAnnotation(annotation)
                
                self.mapView.moveTo(coordinate: coordinate, with: 0.01)
            }
        }
    }
}

