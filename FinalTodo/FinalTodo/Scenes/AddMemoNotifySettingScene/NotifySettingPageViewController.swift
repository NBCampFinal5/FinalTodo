import MapKit
import UIKit

protocol NotifySettingDelegate: AnyObject {
    func didCompleteNotifySetting()
    func didResetNotifySetting()
}

class NotifySettingPageViewController: UIViewController {
    weak var delegate: NotifySettingDelegate?
    var initialTime: Date? // 사용자가 이전에 설정한 시간을 저장하기 위한 변수

    // 오전/오후,시,분 배열
    var amPm = ["오전", "오후"]
    var hours = Array(1...12)
    let minutes = Array(0...59)

    private let topView = ModalTopView(title: "알림 설정")
    private let viewModel: AddMemoPageViewModel
    private var cellHeight: CGFloat = 0

    // MARK: - init

    init(viewModel: AddMemoPageViewModel, initialTime: Date? = nil) {
        self.viewModel = viewModel
        self.initialTime = initialTime ?? viewModel.selectedTime

        super.init(nibName: nil, bundle: nil)
//        timeSettingCellView.stateSwitch.isOn = viewModel.timeState.value
//        locateSettingCellView.stateSwitch.isOn = viewModel.locateState.value
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var timePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("설정완료", for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor02
        button.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTappedDoneButton), for: .touchUpInside)
        return button
    }()

    lazy var resetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("설정초기화", for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor02
        button.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTappedResetButton), for: .touchUpInside)
        return button
    }()
}

extension NotifySettingPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // canceledTime이 있으면 그 시간으로 설정, 없으면 초기 시간 또는 현재 시간으로 설정
        initialTime = viewModel.selectedTime
        setPickerToSelectedTime()
    }
}

private extension NotifySettingPageViewController {
    // MARK: - SetUp

    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        setUpTopView()
        setUpPickerView()
        setUpDoneButton()
        setUpCancelButton()
    }

    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    func setUpPickerView() {
        view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }

    func setUpDoneButton() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timePickerView.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }

    func setUpCancelButton() {
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(doneButton.snp.bottom).offset(10)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }

    // 성준 - timePickerView에 현재 시간으로 시작
    private func setPickerToCurrentTime() {
        let currentDate = Date()
        let calendar = Calendar.current

        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinute = calendar.component(.minute, from: currentDate)

        // 오전과 오후 선택
        let currentAmPmIndex = currentHour < 12 ? 0 : 1

        // 24시간을 -> 12시간 형식으로 변환
        let currentHourIn12HourFormat = currentHour > 12 ? currentHour - 12 : (currentHour == 0 ? 12 : currentHour)

        timePickerView.selectRow(currentAmPmIndex, inComponent: 0, animated: false)
        timePickerView.selectRow(currentHourIn12HourFormat - 1, inComponent: 1, animated: false)
        timePickerView.selectRow(currentMinute, inComponent: 2, animated: false)
    }

    private func setPickerToSelectedTime() {
        let targetTime: Date = initialTime ?? Date() // 초기 시간이 설정되어 있으면 사용, 아니면 현재 시간 사용
        let calendar = Calendar.current

        let currentHour = calendar.component(.hour, from: targetTime)
        let currentMinute = calendar.component(.minute, from: targetTime)

        let currentAmPmIndex = currentHour < 12 ? 0 : 1
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

    // 성준 - 알림 스케줄 메서드 추가
    func scheduleTimeNotification() {
        Notifications.shared.scheduleNotification(title: "시간 알림", body: "설정한 시간에 대한 알림입니다.")
    }

    // 설정완료 버튼 동작 메서드
    @objc func didTappedDoneButton() {
        let hour: Int
        if timePickerView.selectedRow(inComponent: 0) == 0 { // 오전
            hour = timePickerView.selectedRow(inComponent: 1) + 1
        } else { // 오후
            hour = timePickerView.selectedRow(inComponent: 1) + 13
        }
        let minute = timePickerView.selectedRow(inComponent: 2)

        let selectedTimeComponents = DateComponents(hour: hour, minute: minute)
        if let selectedTime = Calendar.current.date(from: selectedTimeComponents) {
            viewModel.tempTime = selectedTime
        }

        // tempTime의 값을 selectedTime에 저장하고 tempTime을 nil로 설정
        viewModel.selectedTime = viewModel.tempTime
        viewModel.tempTime = nil

        delegate?.didCompleteNotifySetting()
        dismiss(animated: true, completion: nil)
    }

    // 설정초기화 버튼 동작 메서드
    @objc func didTappedResetButton() {
        // 현재 시간을 viewModel.tempTime 및 viewModel.selectedTime에 저장
        let currentTime = Date()
        viewModel.tempTime = currentTime
        viewModel.selectedTime = currentTime
        delegate?.didResetNotifySetting()
        dismiss(animated: true, completion: nil)
    }
}

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
