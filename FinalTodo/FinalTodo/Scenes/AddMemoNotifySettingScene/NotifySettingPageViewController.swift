//
//  LocateSettingViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import MapKit
import UIKit

class NotifySettingPageViewController: UIViewController {
    // 성준 - 오전/오후,시,분 배열 설정추가
    var amPm = ["오전", "오후"]
    var hours = Array(1...12)
    let minutes = Array(0...59)

    private let topView = ModalTopView(title: "알림 설정")
    private let scrollView = UIScrollView()
    private let scrollViewContainer = UIView()
    private let timeSettingCellView = NotifySettingItemView(title: "시간")
    private let timeSettingView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 성준 - 시간 설정 pickerView 추가
    lazy var timePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    // 성준 - 설정완료 버튼 추가
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("설정완료", for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor02
        button.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTappedDoneButton), for: .touchUpInside)
        return button
    }()
}

extension NotifySettingPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // 성준 - 현재 시간 설정 추가
        setPickerToCurrentTime()
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
        // 성준 - timePickerView를 timeSettingView에 추가
        timeSettingView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }

        timeSettingView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timePickerView.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
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

    // 성준 - timePickerView에 현재 시간으로 시작
    private func setPickerToCurrentTime() {
        let currentDate = Date()
        let calendar = Calendar.current

        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinute = calendar.component(.minute, from: currentDate)

        // 성준 - 오전과 오후 선택
        let currentAmPmIndex = currentHour < 12 ? 0 : 1

        // 성준 - 24시간을 -> 12시간 형식으로 변환
        let currentHourIn12HourFormat = currentHour > 12 ? currentHour - 12 : (currentHour == 0 ? 12 : currentHour)

        timePickerView.selectRow(currentAmPmIndex, inComponent: 0, animated: false)
        timePickerView.selectRow(currentHourIn12HourFormat - 1, inComponent: 1, animated: false)
        timePickerView.selectRow(currentMinute, inComponent: 2, animated: false)
    }
}

extension NotifySettingPageViewController {
    // MARK: - Method

    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    @objc func didTapToggle(_ button: UISwitch) {
        switch button {
        case timeSettingCellView.stateSwitch:
            if timeSettingCellView.stateSwitch.isOn {
                timeSettingView.isHidden.toggle()
                timeSettingView.snp.remakeConstraints { make in
                    make.top.equalTo(timeSettingCellView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(Constant.screenWidth)
                }
                scheduleTimeNotification() // 알림 스케줄 메서드 호출
            } else {
                timeSettingView.isHidden.toggle()
                timeSettingView.snp.remakeConstraints { make in
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

    // 성준 - 알림 스케줄 메서드 추가
    func scheduleTimeNotification() {
        Notifications.shared.scheduleNotification(title: "시간 알림", body: "설정한 시간에 대한 알림입니다.")
    }

    // 성준 - 완료버튼탭 추가
    @objc func didTappedDoneButton() {
        timeSettingCellView.stateSwitch.isOn = false // 스위치를 비활성화 상태로 설정
        didTapToggle(timeSettingCellView.stateSwitch)
    }
}

// 성준 - timePickerView 추가
extension NotifySettingPageViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 각 컴포넌트의 행 수 설정
        switch component {
        case 0: return amPm.count
        case 1: return hours.count
        case 2: return minutes.count
        default: return 0
        }
    }
}

extension NotifySettingPageViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return amPm[row]
        case 1: return "\(hours[row])시"
        case 2: return "\(minutes[row])분"
        default: return nil
        }
    }
}
