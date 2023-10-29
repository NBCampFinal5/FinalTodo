import SnapKit
import UIKit

class DdayPageViewController: UIViewController {
    var completion: ((Date) -> Void)?
    let dateModel = DdayDateModel()

    lazy var ddayPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        doneButton.tintColor = .black
        navigationItem.rightBarButtonItem = doneButton
    }

    // "완료" 버튼을 누를 시 호출
    @objc func didTapDoneButton() {
        let selectedYear = dateModel.years[ddayPickerView.selectedRow(inComponent: 0)]
        let selectedMonth = dateModel.months[ddayPickerView.selectedRow(inComponent: 1)]
        let selectedDay = dateModel.days[ddayPickerView.selectedRow(inComponent: 2)]
        let selectedDate = "\(selectedYear)-\(selectedMonth)-\(selectedDay)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let date = formatter.date(from: selectedDate) {
            completion?(date)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension DdayPageViewController {
    func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(ddayPickerView)

        ddayPickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
        case 0: return dateModel.years.count
        case 1: return dateModel.months.count
        case 2: return dateModel.days.count
        default: return 0
        }
    }
}

extension DdayPageViewController: UIPickerViewDelegate {
    // 각 컴포넌트와 행에 표시될 내용 설정
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(dateModel.years[row])년"
        case 1: return "\(dateModel.months[row])월"
        case 2: return "\(dateModel.days[row])일"
        default: return nil
        }
    }
}
