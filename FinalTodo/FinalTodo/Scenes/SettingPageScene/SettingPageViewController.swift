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
//        title = "설정"
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
            SettingOption(icon: "pencil", title: "폰트 스타일")
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
        // present -> 상세설정 페이지
    }
}
