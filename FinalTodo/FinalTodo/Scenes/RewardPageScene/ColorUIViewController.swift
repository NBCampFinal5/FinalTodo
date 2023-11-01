//
//  ColorUiViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/26/23.
//

import SnapKit
import UIKit

class ColorUIViewController: UIViewController, UIColorPickerViewControllerDelegate {
    private let manager = CoreDataManager.shared
    lazy var user = manager.getUser()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    var settingOptionData: [[SettingOption]] = [
        [SettingOption(icon: "paintpalette", title: "기본컬러", showSwitch: true, isOn: false),
         SettingOption(icon: "paintpalette.fill", title: "테마컬러 설정", showSwitch: false, isOn: false)],
        [SettingOption(icon: "moon.stars", title: "다크모드", showSwitch: true, isOn: false)]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpTableView()
        setUpColorPicker()

        print("@@", manager.getUser())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        user = manager.getUser()
    }
}

private extension ColorUIViewController {
    // MARK: - SetUp

    func setUp() {
        navigationItem.title = "테마컬러"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
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

extension ColorUIViewController {
    private func setUpColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.supportsAlpha = true
        colorPicker.modalPresentationStyle = .popover

        addChild(colorPicker)
    }

    private func showColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = .myPointColor
        picker.supportsAlpha = true

        present(picker, animated: true, completion: nil)
    }

    func showColorPicker(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = UIColor.cyan
        picker.supportsAlpha = true
        present(picker, animated: true, completion: nil)
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if user.id == "error" {
            let alert = UIAlertController(title: "오류", message: "로그인이 필요합니다", preferredStyle: .alert)
            let yes = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(yes)
            present(alert, animated: true)
        } else {
            let color = viewController.selectedColor.toHexString()
            let updateUser = UserData(id: user.id, nickName: user.nickName, folders: user.folders, memos: user.memos, rewardPoint: user.rewardPoint, rewardName: user.rewardName, themeColor: color)
            manager.updateUser(targetId: user.id, newUser: updateUser) {
                print("Update Color")
            }
            UIColor.myPointColor = UIColor(hex: color)
        }
        viewController.dismiss(animated: true) { [self] in
            user = manager.getUser()
            tableView.reloadData()
        }
    }
}

extension ColorUIViewController: UITableViewDelegate, UITableViewDataSource {
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

        if indexPath.section == 0 && indexPath.row == 0 {
            let model = settingOptionData[0][indexPath.row]
            cell.configure(with: model)
            cell.accessoryView = .none
            cell.accessoryType = .none

        } else if indexPath.section == 0 && indexPath.row == 1 {
            let model = settingOptionData[0][indexPath.row]
            cell.configure(with: model)
            cell.accessoryType = .disclosureIndicator

            let colorView: UIView = {
                let view = UIView()
                view.backgroundColor = .myPointColor
                view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                view.layer.cornerRadius = 5
                return view
            }()
            cell.accessoryView = colorView

        } else if indexPath.section == 1 {
            let model = settingOptionData[1][indexPath.row]
            cell.configure(with: model)
            cell.accessoryView = .none
            cell.accessoryType = .none
        }

        cell.backgroundColor = .secondarySystemBackground
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 && indexPath.row == 0 {
            // 기본컬러 설정 로직 필요
            let color = UIColor.secondaryLabel.toHexString()
            let updateUser = UserData(id: user.id, nickName: user.nickName, folders: user.folders, memos: user.memos, rewardPoint: user.rewardPoint, rewardName: user.rewardName, themeColor: color)
            manager.updateUser(targetId: user.id, newUser: updateUser) { [self] in
                user = manager.getUser()
                tableView.reloadData()
            }

        } else if indexPath.section == 0 && indexPath.row == 1 {
            // 테마컬러 설정
            showColorPicker()

        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 다크모드 기능 구현 필요
        }
    }
}
