import UIKit

class DdayPageViewController: UIViewController {
    var pickerView: UIPickerView!
    var completion: ((Date) -> Void)?

    // 년, 월, 일을 표시하기 위한 배열
    var years: [Int] = []
    var months: [Int] = Array(1...12)
    var days: [Int] = Array(1...31)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPickerView()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTappedDoneButton))
        doneButton.tintColor = .black
        navigationItem.rightBarButtonItem = doneButton
    }

    // UIPickerView 설정
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        // setup
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 현재 연도부터 10년 후까지를 표시하기 위한 범위 설정
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(currentYear...(currentYear + 10))
    }

    // "완료" 버튼을 누를 시 호출
    @objc func didTappedDoneButton() {
        let selectedYear = years[pickerView.selectedRow(inComponent: 0)]
        let selectedMonth = months[pickerView.selectedRow(inComponent: 1)]
        let selectedDay = days[pickerView.selectedRow(inComponent: 2)]
        let selectedDate = "\(selectedYear)-\(selectedMonth)-\(selectedDay)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let date = formatter.date(from: selectedDate) {
            completion?(date)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension DdayPageViewController: UIPickerViewDataSource {
    // UIPickerView의 컴포넌트 수 설정 (년, 월, 일)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    // 각 컴포넌트의 행 수 설정
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return years.count
        case 1: return months.count
        case 2: return days.count
        default: return 0
        }
    }
}

extension DdayPageViewController: UIPickerViewDelegate {
    // 각 컴포넌트와 행에 표시될 내용 설정
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(years[row])년"
        case 1: return "\(months[row])월"
        case 2: return "\(days[row])일"
        default: return nil
        }
    }
}
