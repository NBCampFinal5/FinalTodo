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
        SettingOption(icon: "highlighter", title: "닉네임 변경", showSwitch: false, isOn: false),
        SettingOption(icon: "highlighter", title: "기니 닉네임 변경", showSwitch: false, isOn: false),
    ]

    lazy var userNickNameText = viewModel.userNickName {
        didSet {
            nickNameLabel.text = "\(userNickNameText)"
        }
    }

    lazy var rewardNickNameText = viewModel.rewardNickName {
        didSet {
            rewardNameLabel.text = "메모를 쓰고 \(rewardNickNameText)를(을) 성장시켜요!"
        }
    }

    private let giniImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gini1")
        return view
    }()

    private lazy var rewardImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapGiniImageButton), for: .touchUpInside)
        button.backgroundColor = .secondarySystemBackground
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: viewModel.giniImage)
//        imageView.contentMode = .scaleAspectFit

        return button
    }()

    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(userNickNameText)"
        label.font = UIFont.preferredFont(forTextStyle: .title2)

        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()

    private lazy var nickIdLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.userId)"
        label.font = UIFont.preferredFont(forTextStyle: .callout)

        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()

    private lazy var rewardNameLabel: UILabel = {
        let label = UILabel()
        label.text = "메모를 쓰고 \(rewardNickNameText)를(을) 성장시켜요!"
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 2
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserData {
            print("@@viewDidLoad")
        }
        setUp()
        setUpImage()
    }
}

private extension ProfilePageViewController {
    func setUp() {
        title = "프로필"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.rowHeight = Constant.screenWidth * 0.1
        tableView.isScrollEnabled = false

        view.addSubview(rewardImageButton)
        view.addSubview(nickNameLabel)
        view.addSubview(nickIdLabel)
        view.addSubview(rewardNameLabel)
        view.addSubview(tableView)
        view.addSubview(deleteAccountButton)

        rewardImageButton.addSubview(giniImageView)

        rewardImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constant.screenWidth * 0.15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constant.screenHeight * 0.2)
        }

        giniImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardImageButton.snp.bottom).offset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenWidth * 0.1)
        }

        nickIdLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenWidth * 0.05)
        }

        rewardNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nickIdLabel.snp.bottom).offset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenWidth * 0.07)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(rewardNameLabel.snp.bottom).offset(Constant.defaultPadding)
            make.bottom.equalTo(deleteAccountButton.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding * 2)
        }
    }

    func setUpImage() {
        var scoreString = viewModel.score.description
        scoreString.removeLast()
        guard let value = Int(scoreString) else { return }
        giniImageView.image = UIImage(named: "gini\(value + 1)")
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
            title = "기니 닉네임 변경"
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
