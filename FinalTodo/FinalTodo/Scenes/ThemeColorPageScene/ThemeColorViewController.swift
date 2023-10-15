//
//  ThemeColorViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import UIKit

class ThemeColorViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    var themeColorOptionData: [ThemeColorOption] = []
    let themeColorOptionManager = ThemeColorOptionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
    }
}

private extension ThemeColorViewController {
    func setUp() {
        title = "테마컬러"
        view.addSubview(tableView)
        themeColorOptionManager.makeThemeColorOptions()
        themeColorOptionData = themeColorOptionManager.getThemeColorOptions()
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(ThemeColorCell.self, forCellReuseIdentifier: ThemeColorCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = Constant.screenWidth / 10
    }
}

extension ThemeColorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeColorOptionData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ThemeColorCell.identifier,
            for: indexPath
        ) as! ThemeColorCell
        let model = themeColorOptionData[indexPath.row]
        cell.configure(with: model)

        // UITableCell.accessoryType
        // 1).checkmark[✔️] 2).detailButton[ℹ️] 3).detailDisclosureButton[ℹ️❭] 4).disclosureIndicator[❭] 5).none
        cell.backgroundColor = ColorManager.themeArray[0].pointColor02
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 각 테마컬러 클릭 시 앱 전체 컬러 변경
    }
}
