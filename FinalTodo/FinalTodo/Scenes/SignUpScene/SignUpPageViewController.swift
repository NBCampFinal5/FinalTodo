//
//  SignUpPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit
//회원가입 페이지
class SignUpPageViewController: UIViewController {
    //맨위에 굵은글자
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하기"
        label.textColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    //유저네임 레이블
    private lazy var userNameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.textColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        return label
    }()
    //유저네임텍스트뷰(첫번째 상자)
    private lazy var userNameTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //유저네임입력바
    private lazy var userNameTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        tf.textColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해주세요.", attributes : [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    //패스워드 레이블
    private lazy var passwordTextLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        return label
    }()
    //비밀번호 텍스트뷰(두번째 검은상자)
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //패스워드 입력바,비밀번호 입력필드
    private lazy var passwordTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        tf.textColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(string: "• • • • • • • •", attributes : [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        tf.isSecureTextEntry = true //비밀번호 안보이게 해주는거
        tf.clearsOnBeginEditing = false
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    //패스워드 레이블
    private lazy var confirmPwTextLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        return label
    }()
    //비밀번호 텍스트뷰(두번째 검은상자)
    private lazy var confirmPwTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //패스워드 입력바,비밀번호 입력필드
    private lazy var confirmPwTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        tf.textColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        tf.attributedPlaceholder = NSAttributedString(string: "• • • • • • • •", attributes : [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        tf.isSecureTextEntry = true //비밀번호 안보이게 해주는거
        tf.clearsOnBeginEditing = false
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    //로그인 버튼
    private lazy var registerButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1), for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //구글가입버튼
    private lazy var googleRegisterButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("구글로 가입하기", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.setImage(UIImage(named: "googlelogo"), for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 85, bottom: 0, right: 235)
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.semanticContentAttribute = .forceLeftToRight
        
        return button
    }()
    //애플가입버튼
    private lazy var appleRegisterButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.3568627451, blue: 0.168627451, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("애플로 가입하기", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "applelogo"), for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 85, bottom: 0, right: 235)
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    
    override func viewDidLoad() {
        //mark
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.99783355, green: 0.9879019856, blue: 0.9188477397, alpha: 1)
        setUp()
        
    }
    
    
    func setUp() {
        
        setUpUserName()
        setUpPasswordName()
        setUpConfirmPassword()
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
        view.addSubview(userNameTextLabel)
        userNameTextLabel.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(Constant.screenHeight * 0.03)
            make.leading.equalTo(Constant.defaultPadding)
        }
        //아이디텍스트필드뷰(네모박스
        view.addSubview(userNameTextFieldView)
        userNameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(userNameTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01 )
            make.centerX.equalTo(view.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        //아이디텍스트필드
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(userNameTextFieldView.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    func setUpPasswordName(){
        //패스워드 텍스트
        view.addSubview(passwordTextLabel)
        passwordTextLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.equalTo(Constant.defaultPadding)
        }
        //두번째 검은상자
        view.addSubview(passwordTextFieldView)
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        //패스워드 텍스트필드
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(passwordTextLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
    func setUpConfirmPassword(){
        //패스워드확인필드
        view.addSubview(confirmPwTextLabel)
        confirmPwTextLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.equalTo(Constant.defaultPadding)
        }
        view.addSubview(confirmPwTextFieldView)
        confirmPwTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(confirmPwTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        view.addSubview(confirmPwTextField)
        confirmPwTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPwTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(passwordTextLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    func setUpButton(){
        
        //버튼들
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPwTextFieldView.snp.bottom).offset(Constant.screenHeight * 0.07)
            make.centerX.equalTo(passwordTextLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        view.addSubview(googleRegisterButton)
        googleRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(Constant.screenHeight * 0.1)
            make.centerX.equalTo(passwordTextLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        view.addSubview(appleRegisterButton)
        appleRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(googleRegisterButton.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.centerX.equalTo(passwordTextLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    //빈곳 누르면 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //가입버튼 누르면 다음화면으로 넘어가는 것 구현
    @objc func registerButtonTapped(){
        
    }
    
    //회원가입 버튼 색갈 바뀌는 함수
    @objc func textFieldEditingChanged(_ textField : UITextField){
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let id = userNameTextField.text, !id.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            registerButton.backgroundColor = #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)
            registerButton.isEnabled = false
            return
        }
        registerButton.backgroundColor = #colorLiteral(red: 0.252848357, green: 0.3557934165, blue: 0.1699097455, alpha: 1)
        registerButton.setTitleColor(#colorLiteral(red: 225, green: 233, blue: 202, alpha: 1), for: .normal)
        registerButton.isEnabled = true
        
    }
    
    
}



