//
//  SettingPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

class SettingPageViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        return table
    }()

    var models = [SettingOption]()

//    private let settingItems1: [String] = ["알림", "테마컬러", "폰트스타일", "프로필", "로그아웃"]
//    private let settingItems2: [String] = ["프로필", "로그아웃"]
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
        view.backgroundColor = .red
        view.addSubview(tableView)
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds

        models = [
            SettingOption(icon: "bell", title: "알림"),
            SettingOption(icon: "paintbrush", title: "테마 컬러"),
            SettingOption(icon: "pencil", title: "폰트 스타일"),
            SettingOption(icon: "person.circle", title: "프로필"),
            SettingOption(icon: "arrow.right.circle", title: "로그아웃")
        ]
    }
}

extension SettingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        let model = models[indexPath.row]
        cell.configure(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // present -> 상세설정 페이지
    }
}
