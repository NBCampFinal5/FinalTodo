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

    let emailTextField = CommandLabelView(title: "이메일", placeholder: "이메일을 입력해 주세요.", isSecureTextEntry: false)
    let nicknameTextField = CommandLabelView(title: "닉네임", placeholder: "닉네임을 입력해 주세요.", isSecureTextEntry: false)
    let passwordTextField = CommandLabelView(title: "비밀번호", placeholder: "패스워드를 입력해 주세요.", isSecureTextEntry: true)
    let checkPasswordTextField = CommandLabelView(title: "비밀번호 확인", placeholder: "패스워드를 재입력해 주세요.", isSecureTextEntry: true)
    let registerButton = ButtonTappedView(title: "가입하기")
    
    let viewModel = SignUpPageViewModel()
    
    override func viewDidLoad() {
        // mark
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
        registerButton.delegate = self
        self.registerButton.changeTitleColor(color: .label)
        self.registerButton.changeButtonColor(color: .secondarySystemBackground)
        self.registerButton.setButtonEnabled(false)
        setUp()
        bind()
        viewModel.loginManager.passwordFind(email: "ghddns34@gmail.com")
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
        view.addSubview(emailTextField)
        emailTextField.addInfoLabel()
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.addInfoLabel()
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpPasswordName() {
        // 패스워드 텍스트
        view.addSubview(passwordTextField)
        passwordTextField.addInfoLabel()
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
        
        view.addSubview(checkPasswordTextField)
        checkPasswordTextField.addInfoLabel()
        checkPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constant.screenHeight * 0.02)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    func setUpButton() {
        // 버튼
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(Constant.screenHeight * 0.07)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
}

extension SignUpPageViewController {
    // MARK: - Method
    
    func bind() {
        
        viewModel.email.bind { [weak self] email in
            guard let self = self else { return }
            if email == "" {
                emailTextField.infoCommandLabel.text = ""
            } else {
                if isValidEmail(email: email){
                    emailTextField.infoCommandLabel.text = "사용 가능여부 조회중"
                    emailTextField.infoCommandLabel.textColor = .systemGray
                    viewModel.loginManager.isAvailableEmail(email: email) { result in
                        if result {
                            self.emailTextField.infoCommandLabel.text = "사용가능한 이메일 입니다."
                            self.emailTextField.infoCommandLabel.textColor = .systemBlue
                        } else {
                            self.emailTextField.infoCommandLabel.text = "이미 사용중인 이메일 입니다."
                            self.emailTextField.infoCommandLabel.textColor = .systemRed
                        }
                        self.isPossibleSingUp()
                    }
                    
                } else {
                    emailTextField.infoCommandLabel.text = "이메일 주소를 정확히 입력해주세요."
                    emailTextField.infoCommandLabel.textColor = .systemRed
                }
            }
            isPossibleSingUp()
        }
        
        viewModel.nickName.bind { [weak self] nickName in
            guard let self = self else { return }
            if nickName == "" {
                nicknameTextField.infoCommandLabel.text = ""
            } else {
                if isValidNickName(nickName: nickName){
                    nicknameTextField.infoCommandLabel.text = "사용가능한 닉네임 입니다."
                    nicknameTextField.infoCommandLabel.textColor = .systemBlue
                } else {
                    nicknameTextField.infoCommandLabel.text = "2글자에서 8글자 사이의 닉네임을 입력해주세요."
                    nicknameTextField.infoCommandLabel.textColor = .systemRed
                }
            }
            isPossibleSingUp()
        }
        
        viewModel.password.bind { [weak self] password in
            guard let self = self else { return }
            if password == "" {
                passwordTextField.infoCommandLabel.text = ""
            } else {
                switch isValidPassword(password: password) {
                case .length:
                    passwordTextField.infoCommandLabel.text = "8글자에서 20자 사이의 비밀번호를 입력해주세요."
                    passwordTextField.infoCommandLabel.textColor = .systemRed
                case .combination:
                    passwordTextField.infoCommandLabel.text = "비밀번호는 숫자, 영문, 특수문자를 조합하여야 합니다."
                    passwordTextField.infoCommandLabel.textColor = .systemRed
                case .special:
                    passwordTextField.infoCommandLabel.text = "비밀번호는 특수문자를 포함되어야 합니다."
                    passwordTextField.infoCommandLabel.textColor = .systemRed
                case .right:
                    passwordTextField.infoCommandLabel.text = "사용가능한 비밀번호 입니다."
                    passwordTextField.infoCommandLabel.textColor = .systemBlue
                }
            }
            isPossibleSingUp()
        }
        
        viewModel.checkPassword.bind { [weak self] password in
            guard let self = self else { return }
            if password == "" {
                checkPasswordTextField.infoCommandLabel.text = ""
            } else {
                if password == viewModel.password.value {
                    checkPasswordTextField.infoCommandLabel.text = "비밀번호가 일치합니다."
                    checkPasswordTextField.infoCommandLabel.textColor = .systemBlue
                } else {
                    checkPasswordTextField.infoCommandLabel.text = "비밀번호가 일치하지 않습니다."
                    checkPasswordTextField.infoCommandLabel.textColor = .systemRed
                }
            }
            isPossibleSingUp()
        }
    }
    
    enum PasswordResult {
        case length
        case combination
        case special
        case right
    }
    
    // email 유효성 검사
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // nickName 유효성 검사
    func isValidNickName(nickName: String) -> Bool {
        return (2...8).contains(nickName.count)
    }
    
    func isValidPassword(password: String) -> PasswordResult {
        
        let lengthreg = ".{8,20}"
        let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
        if lengthtesting.evaluate(with: password) == false {
            return .length
        }
        let combinationreg = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        let combinationtesting = NSPredicate(format: "SELF MATCHES %@", combinationreg)
        if combinationtesting.evaluate(with: password) == false {
            return .combination
        }
        let specialreg = "^(?=.*[!@#$%^&*()_+=-]).{8,20}"
        let specialtesting = NSPredicate(format: "SELF MATCHES %@", specialreg)
        if specialtesting.evaluate(with: password) == false {
            return .special
        }
        return .right
    }
    
    func isSignUpAble(state: Bool) {
        UIView.animate(withDuration: 0.3) {
            if state {
                self.registerButton.changeTitleColor(color: .systemGray4)
                self.registerButton.changeButtonColor(color: .secondaryLabel)
                self.registerButton.setButtonEnabled(true)
            } else {
                self.registerButton.changeTitleColor(color: .label)
                self.registerButton.changeButtonColor(color: .secondarySystemBackground)
                self.registerButton.setButtonEnabled(false)
            }
        }
    }
    
    func isPossibleSingUp() {
        
        guard let emailText = emailTextField.infoCommandLabel.text,
              let nickNameText = nicknameTextField.infoCommandLabel.text,
              let passwordText = passwordTextField.infoCommandLabel.text,
              let checkPasswordText = checkPasswordTextField.infoCommandLabel.text else { return }

        if emailText == "사용가능한 이메일 입니다." &&
            nickNameText == "사용가능한 닉네임 입니다." &&
            passwordText == "사용가능한 비밀번호 입니다." &&
            checkPasswordText == "비밀번호가 일치합니다."{
            isSignUpAble(state: true)
        } else {
            isSignUpAble(state: false)
        }
    }

    // 빈곳 누르면 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 가입버튼 누르면 다음화면으로 넘어가는 것 구현
    func didTapButton(button: UIButton) {
        print("@@@ didtapSingUpButton")
//        let user = UserData(
//            id: viewModel.email.value,
//            nickName: viewModel.nickName.value,
//            folders: [],
//            memos: [],
//            rewardPoint: 0,
//            rewardName: "",
//            themeColor: "error")
        
        
        viewModel.loginManager.trySignUp(email: viewModel.email.value, password: viewModel.password.value, nickName: viewModel.password.value) { [weak self] result in
            guard let self = self else { return }
            if result.isSuccess {
                print("Create User")
                let alert = UIAlertController(title: "회원가입 완료", message: "확인을 누르면 로그인 화면으로 돌아 갑니다.", preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .default) { action in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yes)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "회원가입 실패", message: result.errorMessage, preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .default) { action in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yes)
                self.present(alert, animated: true)
            }
        }



        
//        self.navigationController?.popViewController(animated: true)
    }
    
    // 회원가입 버튼 색갈 바뀌는 함수
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        switch textField {
        case emailTextField.inputTextField:
            viewModel.email.value = text
        case nicknameTextField.inputTextField:
            viewModel.nickName.value = text
        case passwordTextField.inputTextField:
            viewModel.password.value = text
        case checkPasswordTextField.inputTextField:
            viewModel.checkPassword.value = text
        default:
            print("등록되지 않은 텍스트 필드")
        }
        
    }
}
