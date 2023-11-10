//
//  SignUpPageView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 11/10/23.
//

import Foundation

class SignUpPageView: UIView {
    
    // 맨위에 굵은글자
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하기"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let emailTextField = CommandLabelView(title: "이메일", placeholder: "이메일을 입력해 주세요.", isSecureTextEntry: false)
    let nicknameTextField = CommandLabelView(title: "닉네임", placeholder: "닉네임을 입력해 주세요.", isSecureTextEntry: false)
    let passwordTextField = CommandLabelView(title: "비밀번호", placeholder: "패스워드를 입력해 주세요.", isSecureTextEntry: true)
    let checkPasswordTextField = CommandLabelView(title: "비밀번호 확인", placeholder: "패스워드를 재입력해 주세요.", isSecureTextEntry: true)
    let registerButton = ButtonTappedView(title: "가입하기")
    
    lazy var privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 처리방침에 동의합니다. ", for: .normal)
        let checkboxImage = UIImage(systemName: "square")
        button.setImage(checkboxImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
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
    
}
