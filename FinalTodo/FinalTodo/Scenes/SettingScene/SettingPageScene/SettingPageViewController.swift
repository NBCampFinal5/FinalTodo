import SnapKit
import UIKit

class SettingPageViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    var settingOptionData: [[SettingOption]] = []
    let settingOptionManager = SettingOptionManager()
}

extension SettingPageViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
}

private extension SettingPageViewController {
    func setUp() {
        navigationItem.title = "설정"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        settingOptionManager.makeSettingOptions()
        settingOptionData = settingOptionManager.getSettingOptions()

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .label
        }
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = Constant.screenWidth / 10
    }
}

extension SettingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingOptionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingOptionData[0].count
        } else if section == 1 {
            return settingOptionData[1].count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        if indexPath.section == 0 {
            let model = settingOptionData[0][indexPath.row]
            cell.configure(with: model)
        } else if indexPath.section == 1 {
            let model = settingOptionData[1][indexPath.row]
            cell.configure(with: model)
        }

        cell.backgroundColor = .secondarySystemBackground
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notifyVC = NotifyPageViewController()
        let themeColorVC = ColorUIViewController()
        let profileVC = ProfilePageViewController()

        if indexPath.section == 0 && indexPath.row == 0 {
            navigationController?.pushViewController(notifyVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 0 && indexPath.row == 1 {
            navigationController?.pushViewController(themeColorVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 0 && indexPath.row == 2 {
            let lockVC = LockSettingViewController()
            navigationController?.pushViewController(lockVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 1 && indexPath.row == 0 {
            navigationController?.pushViewController(profileVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 1 && indexPath.row == 1 {
            let signInVC = SignInPageViewController()
            let manager = LoginManager()
            manager.signOut()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: signInVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 2 {
            let vc = AppInfoViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
