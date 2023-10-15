import SnapKit
import UIKit

class SettingPageViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    var sectionData01 = [SettingOption]()
    var sectionData02 = [SettingOption]()
}

extension SettingPageViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
    }
}

private extension SettingPageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        title = "설정"
        view.addSubview(tableView)
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)

        sectionData01 = [
            SettingOption(icon: "bell", title: "알림"),
            SettingOption(icon: "paintbrush", title: "테마 컬러"),
            SettingOption(icon: "lock", title: "잠금모드")
        ]

        sectionData02 = [
            SettingOption(icon: "person.circle", title: "프로필"),
            SettingOption(icon: "arrow.right.circle", title: "로그아웃")
        ]
    }
}

extension SettingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sectionData01.count
        } else if section == 1 {
            return sectionData02.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell

        if indexPath.section == 0 {
            let model = sectionData01[indexPath.row]
            cell.configure(with: model)
        } else if indexPath.section == 1 {
            let model = sectionData02[indexPath.row]
            cell.configure(with: model)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 성준 - 셀 선택상태 해제(셀 터치시 한번만 터치되게끔)
        
        let notifyVC = NotifyPageViewController() // 성준
        let themeColorVC = ThemeColorViewController()
//        let lockVC = ThemeColorViewController

        let profileVC = ProfilePageViewController()
        let singInVC = SignInPageViewController()

        if indexPath.section == 0 && indexPath.row == 0 {
            // 알림 화면으로 이동
            navigationController?.pushViewController(notifyVC, animated: true) // 성준
        } else if indexPath.section == 0 && indexPath.row == 1 {
            // 테마컬러 화면으로 이동 ☑️
            navigationController?.pushViewController(themeColorVC, animated: false)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            // 잠금화면으로 이동
//            navigationController?.pushViewController(lockVC, animated: false)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 프로필 화면으로 이동 ☑️
            navigationController?.pushViewController(profileVC, animated: false)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            // 로그인 화면으로 이동 ☑️
            navigationController?.pushViewController(singInVC, animated: false)
        }
    }
}
