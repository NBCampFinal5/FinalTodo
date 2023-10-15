//
//  SettingPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

class SettingPageViewController: UIViewController {
    // 접근 제어(open>public>internal(default)>File-private>private), 특정 코드의 세부구현 감추고 필요한 만큼만 공개해서 정보 보호
    // private: 선언된 중괄호{} 내부에서만 사용 가능
    // lazy var: lazy var 저장 변수는 사용되기 전까지 초기값이 계산되지 않는 프로퍼티, 그래서 항상 var로 선언. let 상수 프로퍼티는 초기화 끝나기 전에 반드시 값을 가져야 하기 때문에. iOS는 app 사용량이 너무 높으면 app을 죽이기 때문에 메모리 관리 필요. lazy 프로퍼티와 관련된 클로저는 그 프로퍼티를 읽을 때만 실행됨. 계산 프로퍼티와 같이 사용 불기(계산 코드블록의 코드 실행 후 값을 반환해야하기 때문). lazy var는 초음에 초기화하지 않아 thread-safe하지 않음. 처음 요청이 있으면 초기화되고 그 값을 저장하고 유지함!
    private let tableView: UITableView = {
        // tableView style 설정 1)plain 2)grouped 3)insetGrouped
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
        view.addSubview(tableView)
        settingOptionManager.makeSettingOptions() // 데이터 만들기
        settingOptionData = settingOptionManager.getSettingOptions() // 데이터매니저에서 데이터 받아오기!
        print("settingOptionData: \(settingOptionData)")
    }

    func setUpTableView() {
        tableView.delegate = self // 테이블뷰 동작 구현 대리자로 해당 뷰컨트롤러 설정
        tableView.dataSource = self // 테이블뷰 구성 구현 대리자로 해당 뷰컨트롤러 설정
        tableView.frame = view.bounds // 화면을 꽉 채우기 위해 오토레이아웃 대신 설정
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier) // 코드로 UI 그릴 시 사용할 셀 등록 필수!
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = Constant.screenWidth / 10 // 테이블뷰 셀 높이는 아이콘 크기보다 크게 설정
    }
}

extension SettingPageViewController: UITableViewDataSource {
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
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SettingPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let notificationVC = ThemeColorViewController
        let themeColorVC = ThemeColorViewController()
//        let lockVC = ThemeColorViewController

        let profileVC = ProfilePageViewController()
        let singInVC = SignInPageViewController()

        if indexPath.section == 0 && indexPath.row == 0 {
            // 알림 화면으로 이동
//            navigationController?.pushViewController(notificationVC, animated: true)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            // 테마컬러 화면으로 이동 ☑️
            navigationController?.pushViewController(themeColorVC, animated: true)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            // 잠금화면으로 이동
//            navigationController?.pushViewController(lockVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 프로필 화면으로 이동 ☑️
            navigationController?.pushViewController(profileVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            // 로그인 화면으로 이동 ☑️
            navigationController?.pushViewController(singInVC, animated: true)
        }
    }
}
