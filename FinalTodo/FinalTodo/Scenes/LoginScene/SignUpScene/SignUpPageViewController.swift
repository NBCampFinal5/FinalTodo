//
//  SignUpPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit
// 회원가입 페이지
// TODO: - Font -> 지정 폰트로 변경
// TODO: - 공용뷰로 작업.
// TODO: - AutoLayout은 상수 x 화면 비율로 계산

class SignUpPageViewController: UIViewController, ButtonTappedViewDelegate, CommandLabelDelegate {
    // 맨위에 굵은글자
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하기"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    let idTextBar = CommandLabelView(title: "이메일", placeholder: "이메일을 입력해 주세요.", isSecureTextEntry: false)
    let nicknameTextField = CommandLabelView(title: "닉네임", placeholder: "닉네임을 입력해 주세요.", isSecureTextEntry: false)
    let pwTextBar = CommandLabelView(title: "비밀번호", placeholder: "패스워드를 입력해 주세요.", isSecureTextEntry: true)
    let confirmPwBar = CommandLabelView(title: "비밀번호 확인", placeholder: "패스워드를 재입력해 주세요.", isSecureTextEntry: true)
    let registerButton = ButtonTappedView(title: "가입하기")
    
    override func viewDidLoad() {
        // mark
        super.viewDidLoad()
        view.backgroundColor = .white
        idTextBar.delegate = self
        pwTextBar.delegate = self
        confirmPwBar.delegate = self
        registerButton.delegate = self
        setUp()
    }
}

private extension SignUpPageViewController {
    // MARK: - SetUp
    
    func setUp() {
        setUpUserName()
        setUpPasswordName()
        setUpButton()
    }
    
    func setUpUserName() {
        // 맨위 가입하기 오토레이아웃
        view.addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.05)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
        // 아이디텍스트
        view.addSubview(idTextBar)
        idTextBar.addInfoLabel()
        idTextBar.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.addInfoLabel()
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextBar.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpPasswordName() {
        // 패스워드 텍스트
        view.addSubview(pwTextBar)
        pwTextBar.addInfoLabel()
        pwTextBar.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
        
        view.addSubview(confirmPwBar)
        confirmPwBar.addInfoLabel()
        confirmPwBar.snp.makeConstraints { make in
            make.top.equalTo(pwTextBar.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    func setUpButton() {
        // 버튼
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPwBar.snp.bottom).offset(Constant.screenHeight * 0.07)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
}

extension SignUpPageViewController {
    // MARK: - Method
    
    // email 유효성 검사
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    // 빈곳 누르면 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 가입버튼 누르면 다음화면으로 넘어가는 것 구현
    func didTapButton(button: UIButton) {
        let nextViewController = SignInPageViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // 회원가입 버튼 색갈 바뀌는 함수
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        
        
    }
}
