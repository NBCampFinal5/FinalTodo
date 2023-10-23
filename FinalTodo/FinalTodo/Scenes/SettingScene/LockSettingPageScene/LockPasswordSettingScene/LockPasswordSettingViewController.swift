//
//  PasswordSettingViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/23/23.
//

import UIKit

class LockPasswordSettingViewController: LockController {
    private let viewModel = LockPasswordSettingViewModel()
}

extension LockPasswordSettingViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        setUp()
        bind()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension LockPasswordSettingViewController {
    override func bind() {
        userInPutPassword.bind { [weak self] inputData in
            guard let self = self else { return }
            lockScreenView.passwordInfoLabel.alpha = 0
            lockScreenView.passwordCollectionView.reloadData()
            if inputData.count == Int(passwordLength) {
                if viewModel.firstPassword.value == "" {
                    viewModel.firstPassword.value = inputData
                    userInPutPassword.value = ""
                } else {
                    if inputData == viewModel.firstPassword.value {
                        userDefaultsManager.setPassword(password: inputData)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        showPasswordMissMatch(type: .different)
                        lockScreenView.passwordCollectionView.shake()
                    }
                }
            }
        }
        viewModel.firstPassword.bind { [weak self] password in
            guard let self = self else { return }
            if password == "" {
                lockScreenView.titleLabel.text = "암호 생성"
            } else {
                lockScreenView.titleLabel.text = "암호 확인"
            }
        }
    }
}
