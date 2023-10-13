//
//  SignInPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit
//로그인페이지
class SignInPageViewController: UIViewController {
    //맨위에 로그인 굵은글자
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    //유저네임 레이블
    private lazy var loginTextLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        return label
    }()
    //로그인텍스트뷰(첫번째 검은상자)
    private lazy var loginTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor01")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //아이디 입력바
    private lazy var loginTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor02")
        tf.textColor = UIColor(named: "theme01PointColor02")
        tf.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해주세요", attributes : [NSAttributedString.Key.foregroundColor: UIColor(named: "theme01PointColor02") ?? .black])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        tf.addTarget(self, action: #selector(changeTextFieldEditing(_:)), for: .editingChanged)
        return tf
    }()
    
    //패스워드 레이블
    private lazy var passwordTextLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    //비밀번호 텍스트뷰(두번째 검은상자)
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor01")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //패스워드 입력바,비밀번호 입력필드
    private lazy var passwordTextField : UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor02")
        tf.textColor = UIColor(named: "theme01PointColor02")
        tf.attributedPlaceholder = NSAttributedString(string: "• • • • • • • •", attributes : [NSAttributedString.Key.foregroundColor: UIColor(named: "theme01PointColor02") ?? .black])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        tf.isSecureTextEntry = true //비밀번호 안보이게 해주는거
        tf.clearsOnBeginEditing = false
        tf.addTarget(self, action: #selector(changeTextFieldEditing(_:)), for: .editingChanged)
        return tf
    }()
    //로그인 버튼
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "theme01PointColor03")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor01"), for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        button.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    //구글로그인버튼
    private lazy var googleLoginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "theme01PointColor01")?.cgColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("구글로 로그인하기", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor01"), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.setImage(UIImage(named: "googlelogo"), for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 70, bottom: 0, right: 235)
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.semanticContentAttribute = .forceLeftToRight
        
        return button
    }()
    //애플로그인버튼
    private lazy var appleLoginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "theme01PointColor01")?.cgColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("애플로 로그인하기", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor01"), for: .normal)
        button.setImage(UIImage(named: "applelogo"), for: .normal)
        button.imageEdgeInsets = .init(top: 5, left: 85, bottom: 5, right: 235)
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    private lazy var haveAccountButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("회원이 아니신가요?", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
        //button.titleLabel?.font = [UIFont systemFontSize: 11] 폰트사이즈 조절 물어보기
        button.isEnabled = false
        button.addTarget(self, action: #selector(tappedHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
}
    extension SignInPageViewController {
        // MARK: - LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor(named: "theme01PointColor02")
            setUp()
        }
    }
    
    
    private extension SignInPageViewController {
        // MARK: - SetUp
        
        func setUp() {
            setUpUserName()
            setUpPasswordName()
            setUpButton()
            
        }
        
        func setUpUserName() {
            view.addSubview(loginLabel)
            //맨위 로그인레이블 오토레이아웃
            loginLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.07)
                make.leading.equalTo(Constant.defaultPadding)
            }
            
            view.addSubview(loginTextLabel)
            //로그인텍스트
            loginTextLabel.snp.makeConstraints { make in
                make.top.equalTo(loginLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
                make.leading.equalTo(Constant.defaultPadding)
            }
            
            view.addSubview(loginTextFieldView)
            //로그인텍스트필드뷰(네모박스
            loginTextFieldView.snp.makeConstraints { make in
                make.top.equalTo(loginTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
            
            view.addSubview(loginTextField)
            //로그인텍스트필드
            loginTextField.snp.makeConstraints { make in
                make.top.equalTo(loginTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
                make.centerX.equalTo(loginTextFieldView.snp.left)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
        }
        
        
        func setUpPasswordName() {
            
            view.addSubview(passwordTextLabel)
            //패스워드 텍스트
            passwordTextLabel.snp.makeConstraints { make in
                make.top.equalTo(loginTextFieldView.snp.bottom).offset(Constant.screenHeight * 0.03)
                make.leading.equalTo(Constant.defaultPadding)
            }
            //패스워드 텍스트 필드뷰(네모)
            view.addSubview(passwordTextFieldView)
            passwordTextFieldView.snp.makeConstraints { make in
                make.top.equalTo(passwordTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
            //패스워드 입력하는곳
            view.addSubview(passwordTextField)
            passwordTextField.snp.makeConstraints { make in
                make.top.equalTo(passwordTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
                make.centerX.equalTo(loginTextFieldView.snp.left)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
        }
        
        func setUpButton() {
            
            view.addSubview(loginButton)
            loginButton.snp.makeConstraints { make in
                make.top.equalTo(passwordTextField.snp.bottom).offset(Constant.screenHeight * 0.09)
                make.centerX.equalTo(loginTextFieldView.snp.left)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
            
            view.addSubview(googleLoginButton)
            googleLoginButton.snp.makeConstraints { make in
                make.top.equalTo(loginButton.snp.bottom).offset(Constant.screenHeight * 0.1)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
            view.addSubview(appleLoginButton)
            appleLoginButton.snp.makeConstraints { make in
                make.top.equalTo(googleLoginButton.snp.bottom).offset(Constant.screenHeight * 0.02)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
            view.addSubview(haveAccountButton)
            haveAccountButton.snp.makeConstraints { make in
                make.top.equalTo(appleLoginButton.snp.bottom).offset(Constant.screenHeight * 0.02)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }
        }
    }
    
    
    extension SignInPageViewController {
        // MARK: - Method
        
        //빈곳 누르면 키보드 내려가는 함수
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        //로그인버튼 누르면 다음화면으로 넘어가는 것 구현
        @objc func tappedLoginButton(){
            
        }
        
        //회원이 아니신가요?누르면 넘어가는 버튼
        @objc func tappedHaveAccountButton(){
            let signUpVC = SignUpPageViewController()
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
        
        
        
        //로그인 버튼 색갈 바뀌는 함수
        @objc func changeTextFieldEditing(_ textField : UITextField){
            if textField.text?.count == 1 {
                if textField.text?.first == " " {
                    textField.text = ""
                    return
                }
            }
            guard
                let id = loginTextField.text, !id.isEmpty,
                let password = passwordTextField.text, !password.isEmpty
            else {
                loginButton.backgroundColor = UIColor(named: "theme01PointColor02")
                loginButton.isEnabled = false
                return
            }
            loginButton.backgroundColor = UIColor(named: "theme01PointColor01")
            loginButton.setTitleColor(UIColor(named: "theme01PointColor02") , for: .normal)
            loginButton.isEnabled = true
            
        }
    }
    
