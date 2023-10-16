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
    private let scrollView = UIScrollView()
    private let scrollViewContainer = UIView()
    private let timeSettingCellView = NotifySettingItemView(title: "시간")
    private let timeSettingView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.isHidden = true
        return view
    }()
    private let locateSettingCellView = NotifySettingItemView(title: "위치")
    private let locateSettingView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.isHidden = true
        return view
    }()
    private let viewModel: AddMemoPageViewModel
    
    private var cellHeight: CGFloat = 0
    
    
    // MARK: - init

    init(viewModel: AddMemoPageViewModel) {
        self.viewModel = viewModel
        timeSettingCellView.stateSwitch.isOn = viewModel.timeState.value
        locateSettingCellView.stateSwitch.isOn = viewModel.locateState.value
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotifySettingPageViewController {
    // MARK: - LifeCycle

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
        setUpScrollView()
        setUpContainerView()
        setUpTimeSettingCellView()
        setUptimeSettingView()
        setUpLocateSettingCellView()
        setUpLocateSettingView()
    }
    
    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpContainerView() {
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    func setUpTimeSettingCellView() {
        scrollViewContainer.addSubview(timeSettingCellView)
        timeSettingCellView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        timeSettingCellView.stateSwitch.addTarget(self, action: #selector(didTapToggle(_:)), for: .valueChanged)
    }
    
    func setUptimeSettingView() {
        scrollViewContainer.addSubview(timeSettingView)
        timeSettingView.snp.makeConstraints { make in
            make.top.equalTo(timeSettingCellView.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    func setUpLocateSettingCellView() {
        scrollViewContainer.addSubview(locateSettingCellView)
        locateSettingCellView.snp.makeConstraints { make in
            make.top.equalTo(timeSettingView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        locateSettingCellView.stateSwitch.addTarget(self, action: #selector(didTapToggle(_:)), for: .valueChanged)
    }
    
    func setUpLocateSettingView() {
        scrollViewContainer.addSubview(locateSettingView)
        locateSettingView.snp.makeConstraints { make in
            make.top.equalTo(locateSettingCellView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension NotifySettingPageViewController {
    // MARK: - Method
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapToggle(_ button: UISwitch) {
        switch button {
        case timeSettingCellView.stateSwitch:
            if timeSettingCellView.stateSwitch.isOn {
                timeSettingView.isHidden.toggle()
                self.timeSettingView.snp.remakeConstraints { make in
                    make.top.equalTo(timeSettingCellView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(Constant.screenWidth)
                }
            } else {
                self.timeSettingView.isHidden.toggle()
                self.timeSettingView.snp.remakeConstraints { make in
                    make.top.equalTo(timeSettingCellView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(0)
                }
            }
        case locateSettingCellView.stateSwitch:
            if locateSettingCellView.stateSwitch.isOn {
                locateSettingView.isHidden.toggle()
                locateSettingView.snp.remakeConstraints { make in
                    make.top.equalTo(locateSettingCellView.snp.bottom)
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(Constant.screenWidth)
                }
            } else {
                locateSettingView.isHidden.toggle()
                locateSettingView.snp.remakeConstraints { make in
                    make.top.equalTo(locateSettingCellView.snp.bottom)
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(0)
                }
            }
        default:
            print("default")
        }

    }

}
