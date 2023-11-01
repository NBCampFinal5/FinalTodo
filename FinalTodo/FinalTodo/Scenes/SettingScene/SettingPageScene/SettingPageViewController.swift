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
        settingOptionManager.makeSettingOptions() // 데이터 만들기
        settingOptionData = settingOptionManager.getSettingOptions() // 데이터매니저에서 데이터 받아오기!
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = .label
        }
    }

    func setUpTableView() {
        tableView.delegate = self // 테이블뷰 동작 구현 대리자로 해당 뷰컨트롤러 설정
        tableView.dataSource = self // 테이블뷰 구성 구현 대리자로 해당 뷰컨트롤러 설정
        tableView.frame = view.bounds // 화면을 꽉 채우기 위해 오토레이아웃 대신 설정
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier) // 셀 등록 필수
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
        tableView.deselectRow(at: indexPath, animated: true) // 성준 - 셀 선택상태 해제(셀 터치시 한번만 터치되게끔)
        let notifyVC = NotifyPageViewController() // 성준
        let themeColorVC = ColorUIViewController()
//        let lockVC = ThemeColorViewController

        let profileVC = ProfilePageViewController()
        let singInVC = SignInPageViewController()

        if indexPath.section == 0 && indexPath.row == 0 {
            // 알림 화면으로 이동
            navigationController?.pushViewController(notifyVC, animated: true) // 성준
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 0 && indexPath.row == 1 {
            // 테마컬러 화면으로 이동
            navigationController?.pushViewController(themeColorVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 0 && indexPath.row == 2 {
            // 잠금화면으로 이동
            let lockVC = LockSettingViewController()
            navigationController?.pushViewController(lockVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 프로필 화면으로 이동
            navigationController?.pushViewController(profileVC, animated: true)
            tabBarController?.tabBar.isHidden = true

        } else if indexPath.section == 1 && indexPath.row == 1 {
            // 로그아웃 버튼 - 로그인 화면으로 이동
            let signInVC = SignInPageViewController()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: signInVC, animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 2 {
            // 로그아웃 버튼 - 로그인 화면으로 이동
            let vc = AppInfoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
