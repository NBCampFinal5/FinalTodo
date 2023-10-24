//
//  ProfilePageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import SnapKit
import UIKit

class ProfilePageViewController: UIViewController {
    let viewModel = ProfilePageViewModel()

    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.idLabelText
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    lazy var nickNameLabel: CommandLabelView = {
        let title = "닉네임"
        let placeholder = viewModel.nickNameLabelPlaceholder
        let view = CommandLabelView(title: title, placeholder: placeholder, isSecureTextEntry: false)
        return view
    }()

    lazy var passwordLabel: CommandLabelView = {
        let title = "비밀번호"
        let placeholder = viewModel.passwordLabelPlaceholder
        let view = CommandLabelView(title: title, placeholder: placeholder, isSecureTextEntry: true)
        return view
    }()

    lazy var passwordCheckLabel: CommandLabelView = {
        let title = "비밀번호 확인"
        let placeholder = viewModel.passwordCheckLabelPlaceholder
        let view = CommandLabelView(title: title, placeholder: placeholder, isSecureTextEntry: true)
        return view
    }()

    lazy var editButton: ButtonTappedView = {
        let title = "수정"
        let view = ButtonTappedView(title: title)
        return view
    }()

    lazy var allertLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다!"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .red
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

private extension ProfilePageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        title = "프로필"
        
        // 프로토콜 델리게이트 패턴
        nickNameLabel.delegate = self
        passwordLabel.delegate = self
        passwordCheckLabel.delegate = self
        editButton.delegate = self

        view.addSubview(idLabel)
        view.addSubview(nickNameLabel)
        view.addSubview(passwordLabel)
        view.addSubview(passwordCheckLabel)
        view.addSubview(editButton)
        view.addSubview(allertLabel)

        idLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constant.screenHeight * 0.1)
            make.centerX.equalToSuperview()
        }

        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(Constant.screenHeight * 0.03)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(Constant.screenHeight * 0.03)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        allertLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalToSuperview()
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    func bind() {
        viewModel.fetchDataFromFirebase() // 파이어베이스에서 유저 정보 가져오기 함수 호출
    }
}

extension ProfilePageViewController: ButtonTappedViewDelegate {
    func didTapButton(button: UIButton) {
        print("🟢didTapButton🟢")
        viewModel.nickNameLabelUserInput = nickNameLabel.inputTextField.text ?? ""
        viewModel.passwordLabelUserInput = passwordLabel.inputTextField.text ?? ""
        viewModel.passwordCheckLabelUserInput = passwordCheckLabel.inputTextField.text ?? ""

        viewModel.updateUserData() // 유저데이터 업데이트 함수 호출
    }
}

extension ProfilePageViewController: CommandLabelDelegate {
    func textFieldEditingChanged(_ textField: UITextField) {
        print("🟢textFieldDidEndEditing🟢")
        if textField == passwordCheckLabel.inputTextField {
            let newPassword = passwordLabel.inputTextField.text ?? ""
            let newPasswordCheck = passwordCheckLabel.inputTextField.text ?? ""

            // 비밀번호와 비밀번호 확인 값이 다르면 allertLabelText를 표시
            if newPassword != newPasswordCheck {
                allertLabel.isHidden = false
            } else {
                allertLabel.isHidden = true
            }
        }
    }
}
