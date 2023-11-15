//
//  ColorUiViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/26/23.
//

import SnapKit
import UIKit

// 셀 분리**
class ColorUIViewController: UIViewController {
    private let manager = CoreDataManager.shared
    lazy var user = manager.getUser()
    var isDefaultColor: Bool = true // 값 복사 struct 타입

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    lazy var settingOptionData: [SettingOption] = [
        SettingOption(icon: "paintpalette", title: "기본컬러", showSwitch: true, isOn: isDefaultColor),
        SettingOption(icon: "paintpalette.fill", title: "테마컬러 설정", showSwitch: false, isOn: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getIsDefaultColor()
        setUpColorPicker()
        print("@@viewDidLoad:\(isDefaultColor)", manager.getUser())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        print("@@viewWillAppear:\(isDefaultColor)", manager.getUser())
    }
}

extension ColorUIViewController {
    func setUp() {
        navigationItem.title = "테마컬러"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = Constant.screenWidth / 10
    }

    func getIsDefaultColor() {
        if user.themeColor == "error" {
            isDefaultColor = true
            print("@@color == error")
        } else {
            isDefaultColor = false
            print("color != error")
        }
    }

    func tableViewReloadData() {
        UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
        print("@@tableViewReloadData")
    }
}

extension ColorUIViewController: UIColorPickerViewControllerDelegate {
    func setUpColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.supportsAlpha = true
        colorPicker.modalPresentationStyle = .popover

        addChild(colorPicker)
    }

    func showColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = .myPointColor
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
            manager.updateUser(targetId: user.id, newUser: updateUser) { [self] in
                user = manager.getUser()
                getIsDefaultColor()
                print("@@Update Color")
            }
            UIColor.myPointColor = UIColor(hex: color)
        }
        viewController.dismiss(animated: true) { [self] in
            user = manager.getUser()
            getIsDefaultColor()
            tableViewReloadData()
            print("@@reloadData")
        }
        navigationController?.configureBar()
        tabBarController?.configureBar()
    }
}

extension ColorUIViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptionData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        if indexPath.row == 0 {
            cell.accessoryView = .none
            cell.accessoryType = .none
            cell.isUserInteractionEnabled = true
            cell.contentView.alpha = 1.0

        } else if indexPath.row == 1 {
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = !isDefaultColor
            cell.contentView.alpha = isDefaultColor ? 0.5 : 1.0

            let colorView: UIView = {
                let view = UIView()
                view.backgroundColor = .myPointColor
                view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                view.layer.cornerRadius = 5
                view.layer.borderColor = UIColor.tertiaryLabel.cgColor
                view.layer.borderWidth = 1
                return view
            }()
            cell.accessoryView = colorView
        }
        print("@@isOn: \(settingOptionData[indexPath.row].isOn)")
        cell.configure(with: settingOptionData[indexPath.row])
        cell.delegate = self
        cell.backgroundColor = .systemBackground
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            // 기본컬러 설정
        } else if indexPath.row == 1 {
            // 테마컬러 설정
            showColorPicker()
        }
    }
}

extension ColorUIViewController: SettingCellDelegate {
    func didChangeSwitchState(_ cell: SettingCell, isOn: Bool) {
        isDefaultColor = isOn
        settingOptionData[0].isOn = isOn // Bool 타입이
        print("@@스위치변경: \(isOn), \(isDefaultColor)")
        if isOn {
            let newUser = UserData(
                id: user.id, nickName: user.nickName, folders: user.folders, memos: user.memos, rewardPoint: user.rewardPoint, rewardName: user.rewardName, themeColor: "error"
            )
            manager.updateUser(targetId: user.id, newUser: newUser) { [self] in
                user = manager.getUser()
                getIsDefaultColor()
                print("@@유저업데이트 및 패치")
                print("@@\(settingOptionData[0].isOn),\(isDefaultColor)")
                print("@@\(UIColor.myPointColor)")
                UIColor.myPointColor = UIColor(hex: CoreDataManager.shared.getUser().themeColor)
                tableViewReloadData()
            }
            print("@@스위치변경1: \(isOn), \(isDefaultColor)")
        } else {
            print("@@스위치변경2: \(isOn), \(isDefaultColor)")
            print("@@\(UIColor.myPointColor)")
            tableViewReloadData()
        }
    }
}
