//
//  PasswordChangeViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/23/23.
//

import UIKit

class LockPasswordChangeViewController: LockController {
    private let viewModel = LockPasswordChangeViewModel()
}
extension LockPasswordChangeViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setUp()
        bind()
    }
}

extension LockPasswordChangeViewController {
    // MARK: - Bind

    override func bind() {
        
        viewModel.isUnlock.bind { [weak self] state in
            guard let self = self else { return }
            if state {
                lockScreenView.titleLabel.text = "새로운 암호 입력"
            } else {
                lockScreenView.titleLabel.text = "암호 입력"
            }
        }
        
        viewModel.firstPassword.bind { [weak self] text in
            guard let self = self else { return }
            if !text.isEmpty {
                lockScreenView.titleLabel.text = "암호 확인"
            }
        }
        
        userInPutPassword.bind { [weak self] inputPassword in
            guard let self = self else { return }
            lockScreenView.passwordCollectionView.reloadData()
            if inputPassword.count == 4 {
                if viewModel.isUnlock.value {
                    // 기존암호를 입력한 후
                    if viewModel.firstPassword.value == "" {
                        viewModel.firstPassword.value = inputPassword
                    } else {
                        if viewModel.firstPassword.value == inputPassword {
                            userDefaultsManager.setPassword(password: inputPassword)
                            navigationController?.popViewController(animated: true)
                        } else {
                            showPasswordMissMatch(type: .different)
                        }
                    }
                } else {
                    // 기존암호를 입력하기 전
                    if inputPassword == lockScreenPassword {
                        viewModel.isUnlock.value = true
                    } else {
                        showPasswordMissMatch(type: .mismatch)
                    }
                }
                userInPutPassword.value = ""
            }
        }
    }
}
