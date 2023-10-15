import UIKit
import SnapKit

class AddNotifyPageViewController: UIViewController {
    var amPm = ["오전", "오후"]
    var hours = Array(1...12)
    let minutes = Array(0...59)

    lazy var timePickerView: UIPickerView = {
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
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTappedDoneButton))
        doneButton.tintColor = .black
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func didTappedDoneButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AddNotifyPageViewController {
    func setup() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        title = "시간 설정"

        view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension AddNotifyPageViewController: UIPickerViewDataSource {
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

extension AddNotifyPageViewController: UIPickerViewDelegate {
    // 각 컴포넌트와 행에 표시될 내용 설정
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return amPm[row]
        case 1: return "\(hours[row])시"
        case 2: return "\(minutes[row])분"
        default: return nil
        }
    }
}
