//
//  LocateSettingViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import UIKit
import MapKit

class NotifySettingPageViewController: UIViewController {

    
    private let topView = ModalTopView(title: "알림 설정")
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension NotifySettingPageViewController {
    // MARK: - SetUp

    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        setUpTopView()
        setUpMapView()
    }
    
    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    func setUpMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.bottom.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
}
