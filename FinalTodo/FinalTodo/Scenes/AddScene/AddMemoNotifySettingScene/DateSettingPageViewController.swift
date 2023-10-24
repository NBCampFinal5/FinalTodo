import UIKit
import UserNotifications

class DateSettingPageViewController: UIViewController {
    // 날짜 설정이 완료될 때 알림을 받기 위한 delegate
    weak var delegate: DateSettingDelegate?
    // 이전에 선택된 날짜 (있는 경우)를 저장하기 위한 변수
    var initialDate: Date?

    private let topView = ModalTopView(title: "날짜 알림")
    private let viewModel: AddMemoPageViewModel

    init(viewModel: AddMemoPageViewModel, initialDate: Date? = nil) {
        self.viewModel = viewModel
        self.initialDate = initialDate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 년도, 월, 일을 위한 배열
    var years: [Int] = Array(1995...2033)
    var months: [Int] = Array(1...12)
    var days: [Int] = Array(1...31)

    // 날짜를 선택하기 위한 UIPickerView
    lazy var datePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    // 설정 완료 버튼
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("설정완료", for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor02
        button.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()

    // 설정 초기화 버튼
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("설정초기화", for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor02
        button.setTitleColor(ColorManager.themeArray[0].pointColor01, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }()

    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapDateTooltip), for: .touchUpInside)
        return button
    }()
}

extension DateSettingPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

        // 초기 날짜가 설정되어 있다면 피커 뷰에 표시 or 현재 날짜로 설정
        if let initialDate = initialDate {
            setDateToPicker(date: initialDate)
        } else {
            setPickerToCurrentDate()
        }
    }
}

extension DateSettingPageViewController {
    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        setUpTopView()
        setUpDatePickerView()
        setUpButtons()
    }

    private func setUpTopView() {
        view.addSubview(topView)
        view.addSubview(infoButton)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        infoButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    private func setUpDatePickerView() {
        view.addSubview(datePickerView)
        datePickerView.delegate = self
        datePickerView.dataSource = self
        datePickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }

    private func setUpButtons() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(datePickerView.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }

        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(doneButton.snp.bottom).offset(10)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }

    // datePickerView에 현재 날짜 표시
    private func setPickerToCurrentDate() {
        let currentDate = Date() // 현재 날짜 및 시간을 가져옴
        let calendar = Calendar.current // 현재 캘린더 정보를 가져옴

        // 현재 년도,월,일을 가져옴
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)

        // 피커 뷰에 년도,월,일을 설정
        datePickerView.selectRow(years.firstIndex(of: currentYear) ?? 0, inComponent: 0, animated: false)
        datePickerView.selectRow(months.firstIndex(of: currentMonth) ?? 0, inComponent: 1, animated: false)
        datePickerView.selectRow(days.firstIndex(of: currentDay) ?? 0, inComponent: 2, animated: false)
    }

    // 뒤로가기 버튼 동작
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    // 설정완료 버튼 동작
    @objc func didTapDoneButton() {
        // UIPickerView에서 선택된 년, 월, 일 값을 가져옴
        let selectedYear = years[datePickerView.selectedRow(inComponent: 0)]
        let selectedMonth = months[datePickerView.selectedRow(inComponent: 1)]
        let selectedDay = days[datePickerView.selectedRow(inComponent: 2)]

        // 선택한 날짜를 Calendar를 사용하여 Date 객체로 변환
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = selectedDay
        if viewModel.selectedTime == nil { // 시간 설정이 완료되지 않았다면
            components.hour = 9 // 오전 9시로 설정
            components.minute = 0
        } else {
            // 이미 설정된 시간이 있는 경우 해당 시간을 사용
            components.hour = calendar.component(.hour, from: viewModel.selectedTime!)
            components.minute = calendar.component(.minute, from: viewModel.selectedTime!)
        }

        // 선택된 날짜 및 시간을 viewModel.tempDate에 저장
        if let selectedDate = calendar.date(from: components) {
            viewModel.tempDate = selectedDate
        }

        // 임시로 저장된 날짜(tempDate)를 최종 선택된 날짜 (selectedDate)에 저장하고 tempDate를 초기화
        viewModel.selectedDate = viewModel.tempDate
        viewModel.tempDate = nil

        let identifier = UUID().uuidString
        viewModel.notificationIdentifier = identifier
        if let notificationDate = viewModel.selectedDate {
            Notifications.shared.scheduleNotificationAtDate(title: "날짜 알림", body: "알림을 확인해주세요", date: notificationDate, identifier: identifier, soundEnabled: true, vibrationEnabled: true)

            // 델리게이트 메서드를 호출하여 날짜 설정이 완료되었음을 알림
            delegate?.didCompleteDateSetting(date: notificationDate)
        }
        dismiss(animated: true, completion: nil)
    }

    // 설정초기화 버튼 동작
    @objc func didTapResetButton() {
        // 현재 날짜를 가져와서 임시 날짜(tempDate) 및 최종 선택된 날짜(selectedDate)에 저장
        let currentDate = Date()
        viewModel.tempDate = currentDate
        viewModel.selectedDate = currentDate

        if let identifier = viewModel.notificationIdentifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            viewModel.notificationIdentifier = nil
        }
        // 델리게이트 메서드를 호출하여 날짜 설정이 초기화되었음을 알립
        delegate?.didResetDateSetting()
        dismiss(animated: true, completion: nil)
    }

    private func setDateToPicker(date: Date) {
        // 사용자의 지역과 시간대를 기반으로 한 캘린더 객체를 생성
        let calendar = Calendar.current

        // 주어진 날짜(date)에서 년, 월, 일 정보를 추출
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        // datePickerView의 년도 컴포넌트(0번 컴포넌트)에서 해당 년도의 인덱스를 찾아 선택
        // 만약 해당 년도를 찾을 수 없으면 0번 인덱스(기본값)를 선택
        datePickerView.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 0, animated: false)
        datePickerView.selectRow(months.firstIndex(of: month) ?? 0, inComponent: 1, animated: false)
        datePickerView.selectRow(days.firstIndex(of: day) ?? 0, inComponent: 2, animated: false)
    }

    @objc func didTapDateTooltip() {
        let alertController = UIAlertController(title: "알림 설정", message: "날짜알림만 설정시 오전 9시에 알림이 옵니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

// 피커 뷰의 데이터 소스 관련 메서드들
extension DateSettingPageViewController: UIPickerViewDataSource {
    // 피커 뷰에 표시될 컴포넌트(열)의 개수(3개)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    // 각 컴포넌트(열)에 표시될 행의 개수(3개)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return years.count
        case 1: return months.count
        case 2: return days.count
        default: return 0
        }
    }
}

// 피커 뷰의 델리게이트 관련 메서드들
extension DateSettingPageViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(years[row])년"
        case 1: return "\(months[row])월"
        case 2: return "\(days[row])일"
        default: return nil
        }
    }
}
