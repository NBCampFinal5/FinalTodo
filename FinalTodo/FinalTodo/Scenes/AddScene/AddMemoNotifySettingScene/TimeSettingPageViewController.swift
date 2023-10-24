import MapKit
import SnapKit
import UIKit
import UserNotifications

class TimeSettingPageViewController: UIViewController {
    weak var delegate: NotifySettingDelegate?
    var initialTime: Date? // 초기 설정된 시간 또는 사용자가 마지막으로 설정한 시간을 저장하기 위한 변수

    // 오전/오후,시,분 배열
    var amPm = ["오전", "오후"]
    var hours = Array(1...12)
    let minutes = Array(0...59)

    private let topView = ModalTopView(title: "시간 알림")
    private let viewModel: AddMemoPageViewModel
    private var cellHeight: CGFloat = 0

    // MARK: - init

    // viewModel, initialTime 매개변수를 받음
    init(viewModel: AddMemoPageViewModel, initialTime: Date? = nil) {
        self.viewModel = viewModel
        self.initialTime = initialTime ?? viewModel.selectedTime

        super.init(nibName: nil, bundle: nil)
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
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()

    lazy var resetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("설정초기화", for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor02
        button.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }()

//    lazy var infoButton: UIButton = {
//        let button = UIButton(type: .infoLight)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(didTapDateTooltip), for: .touchUpInside)
//        return button
//    }()
}

extension TimeSettingPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        initialTime = viewModel.selectedTime
        setPickerToSelectedTime()
        UNUserNotificationCenter.current().delegate = self
    }
}

private extension TimeSettingPageViewController {
    // MARK: - SetUp

    func setUp() {
        view.backgroundColor = .systemBackground
        setUpTopView()
        setUpPickerView()
        setUpDoneButton()
        setUpResetButton()
    }

    func setUpTopView() {
        view.addSubview(topView)
        // view.addSubview(infoButton)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

//        infoButton.snp.makeConstraints { make in
//            make.top.left.equalToSuperview().inset(Constant.defaultPadding)
//        }
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

    func setUpResetButton() {
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(doneButton.snp.bottom).offset(10)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }

    // 현재 시간을 피커 뷰에 설정하는 함수
    private func setPickerToCurrentTime() {
        let currentDate = Date() // 현재 날짜 및 시간을 가져옴
        let calendar = Calendar.current // 현재 캘린더 정보를 가져옴

        let currentHour = calendar.component(.hour, from: currentDate) // 현재 시간을 가져옴 (24시간 형식)
        let currentMinute = calendar.component(.minute, from: currentDate) // 현재 분을 가져옴

        // 오전(0) 또는 오후(1)를 결정
        let currentAmPmIndex = currentHour < 12 ? 0 : 1

        // 24시간을 -> 12시간 형식으로 변환
        let currentHourIn12HourFormat = currentHour > 12 ? currentHour - 12 : (currentHour == 0 ? 12 : currentHour)

        // 피커 뷰에 오전/오후, 시간, 분을 설정
        timePickerView.selectRow(currentAmPmIndex, inComponent: 0, animated: true)
        timePickerView.selectRow(currentHourIn12HourFormat - 1, inComponent: 1, animated: true)
        timePickerView.selectRow(currentMinute, inComponent: 2, animated: true)
    }

    // 초기 설정된 시간 또는 현재 시간을 피커 뷰에 설정하는 함수
    private func setPickerToSelectedTime() {
        let targetTime: Date = initialTime ?? Date() // 초기 시간이 설정되어 있으면 사용, 아니면 현재 시간을 사용
        let calendar = Calendar.current

        let currentHour = calendar.component(.hour, from: targetTime)
        let currentMinute = calendar.component(.minute, from: targetTime)

        let currentAmPmIndex = currentHour < 12 ? 0 : 1
        let currentHourIn12HourFormat = currentHour > 12 ? currentHour - 12 : (currentHour == 0 ? 12 : currentHour)

        timePickerView.selectRow(currentAmPmIndex, inComponent: 0, animated: true)
        timePickerView.selectRow(currentHourIn12HourFormat - 1, inComponent: 1, animated: true)
        timePickerView.selectRow(currentMinute, inComponent: 2, animated: true)
    }

//    @objc func didTapDateTooltip() {
//        let alertController = UIAlertController(title: "알림 설정", message: "시간알림만 설정시 매일 해당 시간에 알림이 옵니다.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "확인", style: .default))
//        present(alertController, animated: true)
//    }
}

extension TimeSettingPageViewController {
    // MARK: - Method

    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    // 설정완료 버튼 동작 메서드
    @objc func didTapDoneButton() {
        let selectedHourIn12HourFormat = hours[timePickerView.selectedRow(inComponent: 1)]
        let selectedAmPm = amPm[timePickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[timePickerView.selectedRow(inComponent: 2)]
        var hour: Int
        if selectedAmPm == "오전" {
            hour = selectedHourIn12HourFormat
        } else {
            hour = selectedHourIn12HourFormat + 12
        }

        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = selectedMinute
        if let selectedTime = calendar.date(from: components) {
            viewModel.selectedTime = selectedTime
            print("설정된 시간: \(selectedTime)")
        }

        // 선택된 날짜 및 시간이 모두 있을 경우에만 알림을 예약
//        if let date = viewModel.selectedDate, let time = viewModel.selectedTime {
//            let combinedComponents = DateComponents(year: calendar.component(.year, from: date),
//                                                    month: calendar.component(.month, from: date),
//                                                    day: calendar.component(.day, from: date),
//                                                    hour: calendar.component(.hour, from: time),
//                                                    minute: calendar.component(.minute, from: time))
//
//            if let combinedDate = calendar.date(from: combinedComponents) {
//                let identifier = UUID().uuidString
//                viewModel.notificationIdentifier = identifier
//                Notifications.shared.scheduleNotificationAtDate(title: "?????????", body: "알림을 확인해주세요", date: combinedDate, identifier: identifier, soundEnabled: true, vibrationEnabled: true)
//                delegate?.didCompleteNotifySetting()
//            }
//        }
        dismiss(animated: true, completion: nil)
    }

    // 설정초기화 버튼 동작 메서드
    @objc func didTapResetButton() {
        // 현재 시간을 가져와서 임시 시간(tempTime) 및 최종 선택된 시간(selectedTime)에 저장
        let currentTime = Date()
        viewModel.tempTime = currentTime
        viewModel.selectedTime = currentTime

        if let identifier = viewModel.notificationIdentifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            viewModel.notificationIdentifier = nil
        }
        // 델리게이트 메서드 호출하여 알림 설정 초기화 알림
        delegate?.didResetNotifySetting()
        setPickerToSelectedTime()
    }
}

extension TimeSettingPageViewController: UIPickerViewDataSource {
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

extension TimeSettingPageViewController: UIPickerViewDelegate {
    // 각 행의 제목을 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return amPm[row]
        case 1: return "\(hours[row])시"
        case 2: return "\(minutes[row])분"
        default: return nil
        }
    }
}

extension TimeSettingPageViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // 알림을 표시하고 소리를 재생합니다.
    }
}
