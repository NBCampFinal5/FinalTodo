import SnapKit
import UIKit

class NotifyPageViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    var notifyOptions = [
        SettingOption(icon: "bell", title: "앱 실행 중 알림", showSwitch: true, isOn: NotifySettingManager.shared.isNotificationEnabled),
        SettingOption(icon: "bell", title: "사운드", showSwitch: true, isOn: NotifySettingManager.shared.isSoundEnabled),
        SettingOption(icon: "bell", title: "진동", showSwitch: true, isOn: NotifySettingManager.shared.isVibrationEnabled),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
}

extension NotifyPageViewController {
    func setup() {
        view.backgroundColor = .secondarySystemBackground
        title = "알림 설정"
        view.addSubview(tableView)
    }

    func setupTableView() {
        tableView.backgroundColor = .secondarySystemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
    }
}

extension NotifyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifyOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        let model = notifyOptions[indexPath.row]
        cell.configure(with: model)
        cell.backgroundColor = .systemBackground
        cell.delegate = self

        // 앱 실행 중 알림이 꺼져있을 경우, 사운드와 진동의 스위치를 비활성화합니다.
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.isUserInteractionEnabled = NotifySettingManager.shared.isNotificationEnabled
            cell.contentView.alpha = NotifySettingManager.shared.isNotificationEnabled ? 1.0 : 0.5
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 { // "시간" 셀이 선택됐을때
            let vc = AddNotifyPageViewController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = self

            present(navController, animated: true, completion: nil)
        }
    }
}

extension NotifyPageViewController: SettingCellDelegate {
    func didChangeSwitchState(_ cell: SettingCell, isOn: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        switch indexPath.row {
        case 0: // 앱 실행 중 알림
            NotifySettingManager.shared.isNotificationEnabled = isOn
            // 알림이 꺼져있을 경우, 사운드와 진동도 꺼짐
            if !isOn {
                NotifySettingManager.shared.isSoundEnabled = false
                NotifySettingManager.shared.isVibrationEnabled = false
            }
            // 관련된 셀들만 업데이트합니다.
            let soundIndexPath = IndexPath(row: 1, section: 0)
            let vibrationIndexPath = IndexPath(row: 2, section: 0)
            tableView.reloadRows(at: [soundIndexPath, vibrationIndexPath], with: .automatic)
        case 1: // 앱 실행 중 사운드
            NotifySettingManager.shared.isSoundEnabled = isOn
        case 2: // 앱 실행 중 진동
            NotifySettingManager.shared.isVibrationEnabled = isOn
        default:
            break
        }
    }
}

extension NotifyPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 0.5)
    }
}
