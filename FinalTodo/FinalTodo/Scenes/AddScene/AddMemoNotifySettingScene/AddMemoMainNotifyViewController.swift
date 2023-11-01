import SnapKit
import UIKit

class AddMemoMainNotifyViewController: UIViewController {
    weak var delegate: AddMemoMainNotifyViewControllerDelegate?
    let viewModel = AddMemoPageViewModel()
    let topView = ModalTopView(title: "날짜 및 시간 알림")

    var settingOptionData: [[SettingOption]] = [
        [
            SettingOption(icon: "calendar", title: "날짜", showSwitch: false, isOn: false),
            SettingOption(icon: "clock", title: "시간", showSwitch: false, isOn: false),
        ],
    ]

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapDateTooltip), for: .touchUpInside)
        return button
    }()

    lazy var reserveButton: ButtonTappedView = {
        let buttonView = ButtonTappedView(title: "예약완료")
        buttonView.anyButton.addTarget(self, action: #selector(didTapReserveButton), for: .touchUpInside)
        return buttonView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpTopView()
        setUpTableView()
        setUpReserveButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 날짜와 시간을 갱신
        if let date = viewModel.selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            settingOptionData[0][0].detailText = formatter.string(from: date)
        }

        if let time = viewModel.selectedTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            settingOptionData[0][1].detailText = formatter.string(from: time)
        }

        // 테이블 뷰를 새로고침하여 변경 사항을 반영
        tableView.reloadData()
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = Constant.screenWidth / 10

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
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

    private func setUpReserveButton() {
        view.addSubview(reserveButton)
        reserveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }

    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    @objc func didTapDateTooltip() {
        let alertController = UIAlertController(title: "알림 설정", message: "날짜와 시간을 모두 설정해야 알림이 예약됩니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }

    @objc func didTapReserveButton() {
        // 날짜와 시간이 모두 설정되어 있을 경우 알림 예약 로직
        if let date = viewModel.selectedDate, let time = viewModel.selectedTime {
            delegate?.didReserveNotification(date: date, time: time)
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

            var combinedComponents = DateComponents()
            combinedComponents.year = dateComponents.year
            combinedComponents.month = dateComponents.month
            combinedComponents.day = dateComponents.day
            combinedComponents.hour = timeComponents.hour
            combinedComponents.minute = timeComponents.minute
            // MemoViewController에 날짜와 시간을 전달합니다.
            if let presenter = presentingViewController as? MemoViewController {
                presenter.didReserveNotification(date: viewModel.selectedDate!, time: viewModel.selectedTime!)
            }
            if let combinedDate = calendar.date(from: combinedComponents) {
                Notifications.shared.scheduleNotificationAtDate(title: "날짜 및 시간 알림", body: "알림을 확인해주세요", date: combinedDate, identifier: "memoNotify", soundEnabled: true, vibrationEnabled: true)
                print("예약된 알림 시간: \(combinedDate)")

                // 토스트 메시지로 예약된 날짜와 시간 보여줌
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                showToast(message: "알림이 \(formatter.string(from: combinedDate))에 예약되었습니다.", duration: 2.0)

                dismiss(animated: true)
            }
        } else {
            // 날짜나 시간 중 하나라도 설정되지 않았을 경우 경고 표시
            let alertController = UIAlertController(title: "경고", message: "날짜와 시간을 모두 설정해주세요", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default))
            present(alertController, animated: true)
        }
    }

    func showToast(message: String, duration: TimeInterval = 3.0) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 0.5
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        // 화면 최상단에 표시하기위함
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.addSubview(toastLabel)

        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(Constant.screenWidth * 0.8)
            make.height.equalTo(Constant.screenHeight * 0.04)
            make.bottom.equalToSuperview().offset(-Constant.screenHeight * 0.20)
        }
        UIView.animate(withDuration: duration, delay: 0.3, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

extension AddMemoMainNotifyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingOptionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptionData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        let model = settingOptionData[indexPath.section][indexPath.row]
        cell.configure(with: model)
        cell.backgroundColor = .secondarySystemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var vc: UIViewController!
        if indexPath.row == 0 {
            vc = DateSettingPageViewController(viewModel: viewModel, initialDate: viewModel.selectedDate) // "날짜" 셀 선택 시
        } else {
            vc = TimeSettingPageViewController(viewModel: viewModel, initialTime: viewModel.selectedTime) // "시간" 셀 선택 시
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension AddMemoMainNotifyViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.6)
    }
}

extension AddMemoMainNotifyViewController: DateSettingDelegate {
    func didCompleteDateSetting(date: Date) {
        viewModel.selectedDate = date
        // 날짜 포맷을 업데이트하고 테이블뷰를 새로고침
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        settingOptionData[0][0].detailText = formatter.string(from: date)
        tableView.reloadData()
    }

    func didResetDateSetting() {
        viewModel.selectedDate = nil
        settingOptionData[0][0].detailText = "날짜를 선택해주세요"
        tableView.reloadData()
    }
}
