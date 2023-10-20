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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension LocationSettingPageViewController {
    // MARK: - SetUp
    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor

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
        searchBar.barTintColor = ColorManager.themeArray[0].backgroundColor
    }

    func configureMapView() {
        view.addSubview(mapView)
    }

    func configureConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.setTitle("설정완료", for: .normal)
        confirmButton.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        confirmButton.backgroundColor = ColorManager.themeArray[0].pointColor02
        confirmButton.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
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
}

extension LocationSettingPageViewController {
    // MARK: - Methods
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    @objc func didTappedConfirmButton() {
    }

}

