import SnapKit
import UIKit

class SettingPageViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    let viewModel = SettingPageViewModel()
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
        navigationController?.configureBar()
        tabBarController?.configureBar()
    }
}

private extension SettingPageViewController {
    func setUp() {
        navigationItem.title = "설정"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = .label
        }
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.rowHeight = Constant.screenWidth / 10
    }
}

extension SettingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingOtions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.settingOtions[0].count
        } else if section == 1 {
            return viewModel.settingOtions[1].count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        if indexPath.section == 0 {
            let model = viewModel.settingOtions[0][indexPath.row]
            cell.configure(with: model)
        } else if indexPath.section == 1 {
            let model = viewModel.settingOtions[1][indexPath.row]
            cell.configure(with: model)
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notifyVC = NotifyPageViewController()
        let themeColorVC = ColorUIViewController()
        let profileVC = ProfilePageViewController()

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                navigationController?.pushViewController(notifyVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            } else if indexPath.row == 1 {
                navigationController?.pushViewController(themeColorVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            } else if indexPath.row == 2 {
                let lockVC = LockSettingViewController()
                navigationController?.pushViewController(lockVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            }

        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                navigationController?.pushViewController(profileVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            } else if indexPath.row == 1 {
                let vc = AppInfoViewController()
                navigationController?.pushViewController(vc, animated: true)
                tabBarController?.tabBar.isHidden = true
            } else if indexPath.row == 2 {
                let privacyPolicyVC = PrivacyPolicyViewController()
                navigationController?.pushViewController(privacyPolicyVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            }
        }
    }
}
