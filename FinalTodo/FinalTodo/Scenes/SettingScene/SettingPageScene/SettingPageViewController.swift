import SnapKit
import UIKit

class SettingPageViewController: UIViewController {
    // 접근 제어(open>public>internal(default)>File-private>private), 특정 코드의 세부구현 감추고 필요한 만큼만 공개해서 정보 보호
    // private: 선언된 중괄호{} 내부에서만 사용 가능
    private let tableView: UITableView = {
        // tableView style 설정 1) plain 2) grouped 3) insetGrouped
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    // ☑️ 코드리뷰 제안1: 이중배열로 변경하는 것이 더 좋을 듯! + SettingDataManager 만들어서 데이터모델 분리 필요!
    var settingOptionData: [[SettingOption]] = [] // 이중배열로 섹션과 열에 들어갈 데이터 표시 후 빈 배열 처리
    let settingOptionManager = SettingOptionManager() // 데이터매니저 인스턴스 생성
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
        title = "설정"
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        view.addSubview(tableView)
        settingOptionManager.makeSettingOptions() // 데이터 만들기
        settingOptionData = settingOptionManager.getSettingOptions() // 데이터매니저에서 데이터 받아오기!
        print("settingOptionData: \(settingOptionData)")
    }

    func setUpTableView() {
        tableView.delegate = self // 테이블뷰 동작 구현 대리자로 해당 뷰컨트롤러 설정
        tableView.dataSource = self // 테이블뷰 구성 구현 대리자로 해당 뷰컨트롤러 설정
        tableView.frame = view.bounds // 화면을 꽉 채우기 위해 오토레이아웃 대신 설정
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier) // 셀 등록 필수
        tableView.backgroundColor = ColorManager.themeArray[0].backgroundColor
        tableView.rowHeight = Constant.screenWidth / 10
    }
}

extension SettingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        return settingOptionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        if section == 0 {
            print("section[0] number: \(settingOptionData[0].count)")
            return settingOptionData[0].count
        } else if section == 1 {
            print("section[1] number: \(settingOptionData[1].count)")
            return settingOptionData[1].count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        if indexPath.section == 0 {
            let model = settingOptionData[0][indexPath.row]
            print("model[0]: \(model)")
            cell.configure(with: model)
        } else if indexPath.section == 1 {
            let model = settingOptionData[1][indexPath.row]
            print("model[1]: \(model)")
            cell.configure(with: model)
        }

        cell.backgroundColor = ColorManager.themeArray[0].pointColor02

        // 셀 악세사리타입 설정
        cell.accessoryType = .disclosureIndicator

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
            navigationController?.pushViewController(themeColorVC, animated: true)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            // 잠금화면으로 이동
            let lockVC = LockSettingViewController()
            navigationController?.pushViewController(lockVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 프로필 화면으로 이동 ☑️
            navigationController?.pushViewController(profileVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            // 로그인 화면으로 이동 ☑️
            navigationController?.pushViewController(singInVC, animated: true)
        }
    }
}
