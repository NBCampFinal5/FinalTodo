//
//  SignUpPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit
//회원가입 페이지
// TODO: - Font -> 지정 폰트로 변경
// TODO: - 공용뷰로 작업.
// TODO: - AutoLayout은 상수 x 화면 비율로 계산

class SignUpPageViewController: UIViewController, ButtonTappedViewDelegate, CommandLabelDelegate {
    
    
    //맨위에 굵은글자
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하기"
        label.textColor = UIColor(named: "theme01PointColor01")
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    let idTextBar = CommandLabelView(title: "아이디", placeholder: "아이디를 입력하세요", isSecureTextEntry: false)
    let pwTextBar = CommandLabelView(title: "비밀번호", placeholder: "• • • • • • • •", isSecureTextEntry: true)
    let confirmPwBar = CommandLabelView(title: "비밀번호 확인", placeholder: "• • • • • • • •", isSecureTextEntry: true)
    let registerButton = ButtonTappedView(title: "가입하기")
    
    
    
    override func viewDidLoad() {
        //mark
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
    
    func setUpUserName(){
        //맨위 가입하기 오토레이아웃
        view.addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.05)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
        //아이디텍스트
        view.addSubview(idTextBar)
        idTextBar.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(Constant.screenHeight * 0.03)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpPasswordName(){
        //패스워드 텍스트
        view.addSubview(pwTextBar)
        pwTextBar.snp.makeConstraints { make in
            make.top.equalTo(idTextBar.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
        
        
        view.addSubview(confirmPwBar)
        confirmPwBar.snp.makeConstraints { make in
            make.top.equalTo(pwTextBar.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    func setUpButton(){
        
        //버튼
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPwBar.snp.bottom).offset(Constant.screenHeight * 0.07)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            //        make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
}

extension SignUpPageViewController {
    // MARK: - Method
    //빈곳 누르면 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //가입버튼 누르면 다음화면으로 넘어가는 것 구현
    func didTapButton() {
        let nextViewController = SignInPageViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //회원가입 버튼 색갈 바뀌는 함수
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        // 모든 텍스트 필드에 내용이 있는지 확인합니다.
        guard
            let id = idTextBar.inputTextField.text, !id.isEmpty,
            let password = pwTextBar.inputTextField.text, !password.isEmpty,
            let confirmPw = confirmPwBar.inputTextField.text, !confirmPw.isEmpty
        else {
            // 하나라도 비어 있는 경우 버튼을 비활성화합니다.
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor(named: "disabledColor")
            return
        }
        
        // 모든 텍스트 필드에 내용이 있는 경우 버튼을 활성화합니다.
        registerButton.isEnabled = true
        registerButton.changeButtonColor(color: UIColor(named: "theme01PointColor01"))
    }
}



