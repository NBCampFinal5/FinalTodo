//
//  ProfilePageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import SnapKit
import UIKit

class ProfilePageViewController: UIViewController {
    private let viewModel = ProfilePageViewModel()

    lazy var Options = [
        SettingOption(icon: "highlighter", title: "닉네임 변경하기!", showSwitch: false, isOn: false),
        SettingOption(icon: "highlighter", title: "리워드 네임 변경하기!", showSwitch: false, isOn: false),
    ]

    lazy var userNickNameText = viewModel.userNickName {
        didSet {
            nickNameLabel.text = "안녕하세요, <\(userNickNameText)> 님!"
        }
    }

    lazy var rewardNickNameText = viewModel.rewardNickName {
        didSet {
            rewardNameLabel.text = "<\(rewardNickNameText)>랑 메모 쓰러 가요!"
        }
    }

    private lazy var rewardImageButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemFill.cgColor
        button.addTarget(self, action: #selector(didTapGiniImageButton), for: .touchUpInside)
        button.backgroundColor = .systemBackground

        let imageView = UIImageView()
        imageView.image = UIImage(named: viewModel.giniImage)
        imageView.contentMode = .scaleAspectFit // 이미지를 원래 비율로 유지하도록 설정

        button.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        return button
    }()

    private lazy var chatView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemFill.cgColor
        view.backgroundColor = .systemBackground
        return view
    }()

    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요, <\(userNickNameText)> 님!"
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()

    private lazy var rewardNameLabel: UILabel = {
        let label = UILabel()
        label.text = "<\(rewardNickNameText)>랑 메모 쓰러 가요!"
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        return table
    }()

    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserData {
            print("@@viewDidLoad")
        }
        setUp()
    }
}

private extension ProfilePageViewController {
    func setUp() {
        title = "프로필"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.rowHeight = Constant.screenWidth / 10
        tableView.isScrollEnabled = false

        view.addSubview(rewardImageButton)
        view.addSubview(chatView)
        chatView.addSubview(nickNameLabel)
        chatView.addSubview(rewardNameLabel)

        view.addSubview(tableView)
        view.addSubview(deleteAccountButton)

        rewardImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.05)
            make.leading.equalToSuperview().inset(Constant.defaultPadding)
            make.width.height.equalTo(Constant.screenWidth * 0.3)
        }

        chatView.snp.makeConstraints { make in
            make.centerY.equalTo(rewardImageButton.snp.centerY)
            make.leading.equalTo(rewardImageButton.snp.trailing).offset(Constant.defaultPadding)
            make.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenWidth * 0.3)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        rewardNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(rewardImageButton.snp.bottom).offset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.3)
            make.leading.trailing.equalToSuperview()
        }

        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            make.centerX.equalToSuperview()
        }
    }

    @objc
    func didTapGiniImageButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 2
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    func showEditAlert(editType: ProfilePageViewModel.EditType, completion: @escaping () -> Void) {
        let title: String

        switch editType {
        case .userNickName:
            title = "유저 닉네임 변경"
        case .rewardNickName:
            title = "리워드 닉네임 변경"
        }

        let alertController = UIAlertController(title: title, message: "닉네임을 입력해주세요.", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "새로운 닉네임"
        }

        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            if let textField = alertController.textFields?.first, let newNickName = textField.text {
                switch editType {
                case .userNickName:
                    self.viewModel.updateNickName(type: .userNickName, newName: newNickName)
                case .rewardNickName:
                    self.viewModel.updateNickName(type: .rewardNickName, newName: newNickName)
                }
            }
            completion()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @objc
    func didTapDeleteAccountButton(_ sender: UIButton) {
        let deleteAccountPageVC = DeleteAccountPageViewController()
        navigationController?.pushViewController(deleteAccountPageVC, animated: true) {}
    }
}

extension ProfilePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        let model = Options[indexPath.row]
        cell.configure(with: model)
        cell.backgroundColor = .secondarySystemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            showEditAlert(editType: ProfilePageViewModel.EditType.userNickName) {
                self.viewModel.fetchUserData {
                    self.userNickNameText = self.viewModel.userNickName
                }
            }

        } else if indexPath.row == 1 {
            showEditAlert(editType: ProfilePageViewModel.EditType.rewardNickName) {
                self.viewModel.fetchUserData {
                    self.rewardNickNameText = self.viewModel.rewardNickName
                }
            }
        }
    }
}
