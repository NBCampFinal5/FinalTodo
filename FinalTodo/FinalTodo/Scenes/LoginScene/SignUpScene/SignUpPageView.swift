//
//  SignUpPageView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 11/10/23.
//

import UIKit
import SnapKit

final class SignUpPageView: UIView {
    // MARK: - Property
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하기"
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    let emailTextField = CommandLabelView(title: "이메일", placeholder: "이메일을 입력해 주세요.", isSecureTextEntry: false)
    let nicknameTextField = CommandLabelView(title: "닉네임", placeholder: "닉네임을 입력해 주세요.", isSecureTextEntry: false)
    let passwordTextField = CommandLabelView(title: "비밀번호", placeholder: "패스워드를 입력해 주세요.", isSecureTextEntry: true)
    let checkPasswordTextField = CommandLabelView(title: "비밀번호 확인", placeholder: "패스워드를 재입력해 주세요.", isSecureTextEntry: true)
    let registerButton = ButtonTappedView(title: "가입하기")
    
    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 처리방침에 동의합니다. ", for: .normal)
        let checkboxImage = UIImage(systemName: "square")
        button.setImage(checkboxImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        
        return button
    }()
    
    let linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("[보기]", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: - 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SignUpPageView {
    // MARK: - SetUp
    
    func setUp() {
        setUpRegisterLabel()
        setUpEmailTextField()
        setUpNickNameTextField()
        setUpPasswordTextField()
        setUpCheckPasswordTextField()
        setUpPrivacyPolicyButton()
        setUpLinkButton()
        setUpRegisterButton()
        registerButton.changeTitleColor(color: .label)
        registerButton.changeButtonColor(color: .secondarySystemBackground)
        registerButton.setButtonEnabled(false)
    }
    
    func setUpRegisterLabel() {
        self.addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.screenHeight * 0.05)
            make.leading.equalTo(Constant.defaultPadding)
        }
    }
    
    func setUpEmailTextField() {
        self.addSubview(emailTextField)
        emailTextField.addInfoLabel()
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpNickNameTextField() {
        self.addSubview(nicknameTextField)
        nicknameTextField.addInfoLabel()
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpPasswordTextField() {
        self.addSubview(passwordTextField)
        passwordTextField.addInfoLabel()
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpCheckPasswordTextField() {
        self.addSubview(checkPasswordTextField)
        checkPasswordTextField.addInfoLabel()
        checkPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpPrivacyPolicyButton() {
        self.addSubview(privacyPolicyButton)
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.left.equalTo(checkPasswordTextField.snp.left).inset(Constant.defaultPadding)
        }
    }
    
    func setUpLinkButton() {
        self.addSubview(linkButton)
        linkButton.snp.makeConstraints { make in
            make.centerY.equalTo(privacyPolicyButton.snp.centerY)
            make.left.equalTo(privacyPolicyButton.snp.right).offset(Constant.defaultPadding / 2)
        }
    }
    
    func setUpRegisterButton() {
        self.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(Constant.screenHeight * 0.07)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

}
