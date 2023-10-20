import MapKit
import UIKit

protocol NotifySettingDelegate: AnyObject {
    func didCompleteNotifySetting() // 알림 설정 완료시 호출될 메서드
    func didResetNotifySetting() // 알림 설정 초기화시 호출될 메서드
}

class NotifySettingPageViewController: UIViewController {
    weak var delegate: NotifySettingDelegate?
    var initialTime: Date? // 초기 설정된 시간 또는 사용자가 마지막으로 설정한 시간을 저장하기 위한 변수

    // 오전/오후,시,분 배열
    var amPm = ["오전", "오후"]
    var hours = Array(1...12)
    let minutes = Array(0...59)

    private let topView = ModalTopView(title: "알림 설정")
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

    // 현재 시간을 피커 뷰에 설정하는 함수
    private func setPickerToCurrentTime() {
        let currentDate = Date()  // 현재 날짜 및 시간을 가져옴
        let calendar = Calendar.current // 현재 캘린더 정보를 가져옴

        let currentHour = calendar.component(.hour, from: currentDate) // 현재 시간을 가져옴 (24시간 형식)
        let currentMinute = calendar.component(.minute, from: currentDate) // 현재 분을 가져옴

        // 오전(0) 또는 오후(1)를 결정
        let currentAmPmIndex = currentHour < 12 ? 0 : 1

        // 24시간을 -> 12시간 형식으로 변환
        let currentHourIn12HourFormat = currentHour > 12 ? currentHour - 12 : (currentHour == 0 ? 12 : currentHour)
        
        // 피커 뷰에 오전/오후, 시간, 분을 설정
        timePickerView.selectRow(currentAmPmIndex, inComponent: 0, animated: false)
        timePickerView.selectRow(currentHourIn12HourFormat - 1, inComponent: 1, animated: false)
        timePickerView.selectRow(currentMinute, inComponent: 2, animated: false)
    }
    // 초기 설정된 시간 또는 현재 시간을 피커 뷰에 설정하는 함수
    private func setPickerToSelectedTime() {
        let targetTime: Date = initialTime ?? Date() // 초기 시간이 설정되어 있으면 사용, 아니면 현재 시간을 사용
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
        let hour: Int // 시간 값을 저장할 변수 초기화
        // 첫 번째 컴포넌트(AM/PM)의 선택된 값이 0 (즉, 오전)인 경우
        if timePickerView.selectedRow(inComponent: 0) == 0 { // 오전인 경우
            // 선택된 시간 값을 hour 변수에 저장 (+1은 선택된 인덱스를 시간 값으로 변환하기 위해)
            hour = timePickerView.selectedRow(inComponent: 1) + 1

        } else { // 오후인 경우
            // 선택된 시간 값에 13를 더하여 hour 변수에 저장 (오후 시간으로 계산)
            hour = timePickerView.selectedRow(inComponent: 1) + 13
        }
        
        // 선택된 분 값을 minute 변수에 저장
        let minute = timePickerView.selectedRow(inComponent: 2)
        // 선택된 시간과 분으로 DateComponents 객체 생성
        let selectedTimeComponents = DateComponents(hour: hour, minute: minute)
        if let selectedTime = Calendar.current.date(from: selectedTimeComponents) {
            viewModel.tempTime = selectedTime
        }

        // 임시로 저장된 시간(tempTime)을 최종 선택된 시간 (selectedTime)에 저장하고 tempTime 초기화
        viewModel.selectedTime = viewModel.tempTime
        viewModel.tempTime = nil
        
        // 델리게이트 메서드 호출하여 알림 설정 완료 알림
        delegate?.didCompleteNotifySetting()
        dismiss(animated: true, completion: nil)
    }

    // 설정초기화 버튼 동작 메서드
    @objc func didTappedResetButton() {
        // 현재 시간을 가져와서 임시 시간(tempTime) 및 최종 선택된 시간(selectedTime)에 저장
        let currentTime = Date()
        viewModel.tempTime = currentTime
        viewModel.selectedTime = currentTime
        
        // 델리게이트 메서드 호출하여 알림 설정 초기화 알림
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
