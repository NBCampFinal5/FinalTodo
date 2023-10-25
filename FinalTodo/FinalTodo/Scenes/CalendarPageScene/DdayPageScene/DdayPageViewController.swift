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

    lazy var ddayTitleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = ColorManager.themeArray[0].pointColor02
        textField.textColor = .black
        textField.placeholder = "D-day 제목을 입력하세요"
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setPickerToCurrentDate()
        
//        ddayTitleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        // 키보드 올라올때 텍스트 필드 움직임 로직 중 하나
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideKeyboardTappedAround()
    }

    func setupNavigationBar() {
        navigationItem.title = "D-day 설정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        doneButton.tintColor = .black
        navigationItem.rightBarButtonItem = doneButton
    }

    // 현재 날짜로 설정
    private func setPickerToCurrentDate() {
        let currentDate = Date() // 현재 날짜 및 시간을 가져옴
        let calendar = Calendar.current // 현재 캘린더 정보를 가져옴

        // 현재 년도,월,일을 가져옴
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)

        // 피커 뷰에 년도,월,일을 설정
        ddayPickerView.selectRow(dateModel.years.firstIndex(of: currentYear) ?? 0, inComponent: 0, animated: true)
        ddayPickerView.selectRow(dateModel.months.firstIndex(of: currentMonth) ?? 0, inComponent: 1, animated: true)
        ddayPickerView.selectRow(dateModel.days.firstIndex(of: currentDay) ?? 0, inComponent: 2, animated: true)
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

            // 선택된 날짜에 대한 안내 메시지 표시
            let alertController = UIAlertController(title: nil, message: "\(selectedDate)로 디데이가 설정되었습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    // 텍스트필드 이외부분 터치했을때 키보드내려감
    func hideKeyboardTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(DdayPageViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // 키보드 올라올때 텍스트 필드 올라감
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardSize.height / 10
            }
        }
    }

    // 키보드 올라올때 텍스트 필드 내려감
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    // 키보드 올라올때 텍스트 필드 움직임 로직 중 하나
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DdayPageViewController {
    func setup() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        view.addSubview(ddayTitleTextField)
        view.addSubview(ddayPickerView)

        ddayTitleTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(ddayPickerView.snp.top).offset(-Constant.defaultPadding)
            make.width.equalTo(Constant.screenWidth * 0.6)
            make.height.equalTo(Constant.screenHeight * 0.04)
        }
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

extension DdayPageViewController: UITextFieldDelegate {
    // 키보드 엔터버튼 return으로 변경, return 버튼 누를시 키보드 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        dismiss(animated: true, completion: nil)

        return true
    }

//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if textField.text?.isEmpty == true {
//            textField.placeholder = "D-day 제목을 입력하세요"
//        } else {
//            textField.placeholder = nil
//        }
//    }
}
