//
//  ProfilePageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import SnapKit
import UIKit

// 과제1: 얼러트로 유저닉네임이랑 리워드닉네임 바꾼 게 바로 뷰컨트롤러에 반영이 안 되는 것
// 과제2: 프로필페이지에서 다른 탭 눌렀다가 설정탭 돌아오면 그대로 프로필페이지인 것
// 과제3: 계정 삭제 뒤 로그인페이지로 돌아가는 화면 전환이 모달로 된 것

class ProfilePageViewController: UIViewController {
    private let viewModel = ProfilePageViewModel()

    lazy var userNickNameText = viewModel.userNickName {
        didSet(newValue) {
            userNickNameEditButton.setTitle(newValue, for: .normal)
        }
    }

    lazy var rewardNickNameText = viewModel.rewardNickName {
        didSet(newValue) {
            rewardNickNameEditButton.setTitle(newValue, for: .normal)
        }
    }

    private lazy var rewardImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: viewModel.giniImage), for: .normal)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(didTapGiniImageButton), for: .touchUpInside)
        button.backgroundColor = .systemBackground
        return button
    }()

    private lazy var userNickNameEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("안녕하세요, <\(userNickNameText)> 님!", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.backgroundColor = .systemGray4
        button.addTarget(self, action: #selector(didTapUserNickNameEditButton), for: .touchUpInside)
        return button
    }()

    private lazy var rewardNickNameEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("<\(rewardNickNameText)>랑 메모 쓰러 가요!", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.backgroundColor = .systemGray4
        button.addTarget(self, action: #selector(didTapRewardNickNameEditButton), for: .touchUpInside)
        return button
    }()

    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUserData()
        setUp()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        rewardImageButton.layer.cornerRadius = rewardImageButton.frame.size.width / 2
//        rewardImageButton.clipsToBounds = true
    }
}

private extension ProfilePageViewController {
    func setUp() {
        title = "프로필"
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor

        view.addSubview(rewardImageButton)
        view.addSubview(userNickNameEditButton)
        view.addSubview(rewardNickNameEditButton)
        view.addSubview(deleteAccountButton)

        rewardImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.05)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constant.screenWidth * 0.3)
        }

        userNickNameEditButton.snp.makeConstraints { make in
            make.top.equalTo(rewardImageButton.snp.bottom).offset(Constant.screenHeight * 0.07)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }

        rewardNickNameEditButton.snp.makeConstraints { make in
            make.top.equalTo(userNickNameEditButton.snp.bottom).offset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
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
        }
    }

    func showEditAlert(editType: ProfilePageViewModel.EditType) {
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
                self.viewModel.fetchUserData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @objc
    func didTapUserNickNameEditButton(_ sender: UIButton) {
        showEditAlert(editType: ProfilePageViewModel.EditType.userNickName)
        sender.setTitle("안녕하세요, <\(userNickNameText)> 님!", for: .normal)
//        sender.setNeedsLayout()
//        sender.layoutIfNeeded()
    }

    @objc
    func didTapRewardNickNameEditButton(_ sender: UIButton) {
        showEditAlert(editType: ProfilePageViewModel.EditType.rewardNickName)
        sender.setTitle("<\(rewardNickNameText)>랑 메모 쓰러 가요!", for: .normal)
//        sender.setNeedsLayout()
//        sender.layoutIfNeeded()
    }

    @objc
    func didTapDeleteAccountButton(_ sender: UIButton) {
        let deleteAccountPageVC = DeleteAccountPageViewController()
        navigationController?.pushViewController(deleteAccountPageVC, animated: true)
    }
}
