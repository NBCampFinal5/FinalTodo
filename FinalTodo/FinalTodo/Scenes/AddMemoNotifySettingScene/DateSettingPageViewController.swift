import UIKit

protocol DateSettingDelegate: AnyObject {
    func didCompleteDateSetting(date: Date) // 날짜 설정이 완료될 때 호출될 메서드를 정의
    func didResetDateSetting()
}

class DateSettingPageViewController: UIViewController {
    // 날짜 설정이 완료될 때 알림을 받기 위한 delegate
    weak var delegate: DateSettingDelegate?
    // 이전에 선택된 날짜 (있는 경우)를 저장하기 위한 변수
    var initialDate: Date?

    private let topView = ModalTopView(title: "날짜 설정")
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
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
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
        let currentDate = Date()
        let calendar = Calendar.current

        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)

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
        let selectedYear = years[datePickerView.selectedRow(inComponent: 0)]
        let selectedMonth = months[datePickerView.selectedRow(inComponent: 1)]
        let selectedDay = days[datePickerView.selectedRow(inComponent: 2)]

        let calendar = Calendar.current
        if let selectedDate = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)) {
            viewModel.tempDate = selectedDate
        }

        // tempDate의 값을 selectedDate에 저장하고 tempDate을 nil로 설정
        viewModel.selectedDate = viewModel.tempDate
        viewModel.tempDate = nil

        // 여기서 delegate 메서드를 호출합니다.
        delegate?.didCompleteDateSetting(date: viewModel.selectedDate!)

        dismiss(animated: true, completion: nil)
    }

    // 설정초기화 버튼 동작
    @objc func didTapResetButton() {
        // 현재 날짜를 viewModel.tempDate 및 viewModel.selectedDate에 저장
        let currentDate = Date()
        viewModel.tempDate = currentDate
        viewModel.selectedDate = currentDate
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
