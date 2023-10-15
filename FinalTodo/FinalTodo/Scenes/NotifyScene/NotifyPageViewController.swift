import SnapKit
import UIKit

class NotifyPageViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    var notifyOptions = [
        SettingOption(icon: "bell", title: "푸시 알림"),
        SettingOption(icon: "clock", title: "시간"),
        SettingOption(icon: "message", title: "메세지")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
}

extension NotifyPageViewController {
    func setup() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        title = "알림 설정"
        view.addSubview(tableView)
    }

    func setupTableView() {
        tableView.backgroundColor = ColorManager.themeArray[0].backgroundColor
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

        cell.backgroundColor = ColorManager.themeArray[0].pointColor02
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
        } else if indexPath.row == 2 { // "메세지" 셀이 선택됐을때
            let vc = AddMessagePageViewController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = self

            present(navController, animated: true, completion: nil)
        }
    }
}

extension NotifyPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 0.5)
    }
}
