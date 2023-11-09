import SnapKit
import UIKit

class AddMemoMainNotifyViewController: UIViewController {
    weak var delegate: AddNotifyDelegate?
    let viewModel: AddMemoPageViewModel
    let topView = ModalTopView(title: "알림 설정")
    var handler: () -> Void = {}

    var settingOptionData: [[SettingOption]] = [
        [
            SettingOption(icon: "calendar", title: "날짜", showSwitch: false, isOn: false),
            SettingOption(icon: "clock", title: "시간", showSwitch: false, isOn: false),
        ],
    ]

    // MARK: - View

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .myPointColor
        button.addTarget(self, action: #selector(didTapDateTooltip), for: .touchUpInside)
        return button
    }()

    lazy var reserveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("예약완료", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapReserveButton), for: .touchUpInside)
        return button
    }()

    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("예약초기화", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }()

    init(viewModel: AddMemoPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle

extension AddMemoMainNotifyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpTopView()
        setUpTableView()
        setUpButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        handler()
    }
}

// MARK: - SetUp

extension AddMemoMainNotifyViewController {
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

    private func setUpButtons() {
        view.addSubview(reserveButton)
        reserveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }

        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(reserveButton.snp.bottom).offset(13)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
    }
}

// MARK: - Method

extension AddMemoMainNotifyViewController {
    @objc func didTapBackButton() {
        viewModel.selectedTime = nil
        viewModel.selectedDate = nil
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
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

            var combinedComponents = DateComponents()
            combinedComponents.year = dateComponents.year
            combinedComponents.month = dateComponents.month
            combinedComponents.day = dateComponents.day
            combinedComponents.hour = timeComponents.hour
            combinedComponents.minute = timeComponents.minute

            if let combinedDate = calendar.date(from: combinedComponents) {
                Notifications.shared.scheduleNotificationAtDate(title: "메모 알림", body: "메모를 확인해주세요", date: combinedDate, identifier: "memoNotify", soundEnabled: true, vibrationEnabled: true)
                print("예약된 알림 시간: \(combinedDate)")
                // 토스트 메시지로 예약된 날짜와 시간 보여줌
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd a hh:mm"
                formatter.locale = Locale(identifier: "ko_KR")

                showToast(message: "알림이 \(formatter.string(from: combinedDate))에 예약되었습니다.", duration: 2.0)

                // ViewModel에 예약된 알림 시간을 설정
                viewModel.timeNotifySetting = formatter.string(from: combinedDate)
                // Delegate에게 알림 설정을 알림
                viewModel.optionImageAry[0] = formatter.string(from: combinedDate)

                delegate?.didReserveNotification(timeNotifySetting: formatter.string(from: combinedDate))
                dismiss(animated: true)
            }
        } else {
            // 날짜나 시간 중 하나라도 설정되지 않았을 경우 경고 표시
            let alertController = UIAlertController(title: "경고", message: "날짜와 시간을 모두 설정해주세요", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default))
            present(alertController, animated: true)
        }
    }

    @objc func didTapResetButton() {
        // 알림 취소 로직
        Notifications.shared.cancelNotification(identifier: "memoNotify")
        print("알림이 취소되었습니다.")

        // ViewModel의 알림 설정 시간을 초기화
        viewModel.timeNotifySetting = nil
        viewModel.selectedTime = nil
        viewModel.selectedDate = nil
        viewModel.optionImageAry[0] = "알림 설정"

        // Delegate에게 알림 취소를 알림
        delegate?.didCancelNotification()
        // 토스트 메시지로 알림 취소를 사용자에게 알림
        showToast(message: "알림이 취소되었습니다.", duration: 2.0)
        dismiss(animated: true, completion: nil)
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
        // 위치와 크기 지정
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

// MARK: - Delegate,DataSource

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
            let dateSettingVC = DateSettingPageViewController(viewModel: viewModel, initialDate: viewModel.selectedDate) // "날짜" 셀 선택 시
            dateSettingVC.delegate = self // 이 부분을 추가합니다.
            vc = dateSettingVC // "날짜" 셀 선택 시
        } else {
            let timeSettingVC = TimeSettingPageViewController(viewModel: viewModel)
            timeSettingVC.delegate = self
            vc = timeSettingVC // "시간" 셀 선택 시
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: date)
        // settingOptionData 배열의 날짜 셀을 업데이트
        settingOptionData[0][0].title = dateString
        tableView.reloadData()
    }

    func didResetDateSetting() {
        // 날짜 설정 초기화 로직
        settingOptionData[0][0].title = "날짜" // 셀을 "날짜"로 재설정
        tableView.reloadData()
    }
}

extension AddMemoMainNotifyViewController: NotifySettingDelegate {
    func didCompleteNotifySetting() {
        //
    }

    func didResetNotifySetting() {
        // 시간 설정 초기화 로직
        settingOptionData[0][1].title = "시간" // 셀을 "시간"으로 재설정
        tableView.reloadData()
    }

    func didCompleteTimeSetting(time: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let timeString = dateFormatter.string(from: time)
        // settingOptionData 배열의 시간 셀을 업데이트
        settingOptionData[0][1].title = "\(timeString)"
        tableView.reloadData()
    }

    func didResetTimeSetting() {
        // 시간 설정 초기화 로직
        settingOptionData[0][1].title = "시간" // 셀을 "시간"으로 재설정
        tableView.reloadData()
    }
}

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // 날짜와 시간을 갱신
//        if let date = viewModel.selectedDate {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            settingOptionData[0][0].detailText = formatter.string(from: date)
//        }
//
//        if let time = viewModel.selectedTime {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH:mm"
//            settingOptionData[0][1].detailText = formatter.string(from: time)
//        }
//
//        // 테이블 뷰를 새로고침하여 변경 사항을 반영
//        tableView.reloadData()
//    }
