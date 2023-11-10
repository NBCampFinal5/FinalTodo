//
//  SignUpPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

final class SignUpPageViewController: UIViewController {
    // MARK: - Property

    private let viewModel = SignUpPageViewModel()
    private let signUpPageView = SignUpPageView()
}

extension SignUpPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

private extension SignUpPageViewController {
    // MARK: - SetUp
    
    func setUp() {
        view.backgroundColor = .systemBackground
        setUpSignUpPageView()
        setUpDelegate()
        setupNavigationBar()
    }
    
    func setUpSignUpPageView() {
        self.view.addSubview(signUpPageView)
        signUpPageView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        signUpPageView.linkButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        signUpPageView.privacyPolicyButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    func setUpDelegate() {
        signUpPageView.emailTextField.delegate = self
        signUpPageView.nicknameTextField.delegate = self
        signUpPageView.passwordTextField.delegate = self
        signUpPageView.checkPasswordTextField.delegate = self
    }

    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func setUpKeyBoardNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

private extension SignUpPageViewController {
    // MARK: - Bind
    func bind() {
        viewModel.email.bind { [weak self] email in
            guard let self = self else { return }
            if email == "" {
                signUpPageView.emailTextField.infoCommandLabel.text = ""
            } else {
                if isValidEmail(email: email) {
                    signUpPageView.emailTextField.infoCommandLabel.text = "사용 가능여부 조회중"
                    signUpPageView.emailTextField.infoCommandLabel.textColor = .systemGray
                    viewModel.loginManager.isAvailableEmail(email: email) { result in
                        if result {
                            self.signUpPageView.emailTextField.infoCommandLabel.text = "사용가능한 이메일 입니다."
                            self.signUpPageView.emailTextField.infoCommandLabel.textColor = .systemBlue
                        } else {
                            self.signUpPageView.emailTextField.infoCommandLabel.text = "이미 사용중인 이메일 입니다."
                            self.signUpPageView.emailTextField.infoCommandLabel.textColor = .systemRed
                        }
                        self.isPossibleSingUp()
                    }
                    
                } else {
                    signUpPageView.emailTextField.infoCommandLabel.text = "이메일 주소를 정확히 입력해주세요."
                    signUpPageView.emailTextField.infoCommandLabel.textColor = .systemRed
                }
            }
            isPossibleSingUp()
        }
        
        viewModel.nickName.bind { [weak self] nickName in
            guard let self = self else { return }
            if nickName == "" {
                signUpPageView.nicknameTextField.infoCommandLabel.text = ""
            } else {
                if isValidNickName(nickName: nickName) {
                    signUpPageView.nicknameTextField.infoCommandLabel.text = "사용가능한 닉네임 입니다."
                    signUpPageView.nicknameTextField.infoCommandLabel.textColor = .systemBlue
                } else {
                    signUpPageView.nicknameTextField.infoCommandLabel.text = "2글자에서 8글자 사이의 닉네임을 입력해주세요."
                    signUpPageView.nicknameTextField.infoCommandLabel.textColor = .systemRed
                }
            }
            isPossibleSingUp()
        }
        
        viewModel.password.bind { [weak self] password in
            guard let self = self else { return }
            if password == "" {
                signUpPageView.passwordTextField.infoCommandLabel.text = ""
            } else {
                switch isValidPassword(password: password) {
                case .length:
                    signUpPageView.passwordTextField.infoCommandLabel.text = "8글자에서 20자 사이의 비밀번호를 입력해주세요."
                    signUpPageView.passwordTextField.infoCommandLabel.textColor = .systemRed
                case .combination:
                    signUpPageView.passwordTextField.infoCommandLabel.text = "비밀번호는 숫자, 영문, 특수문자를 조합하여야 합니다."
                    signUpPageView.passwordTextField.infoCommandLabel.textColor = .systemRed
                case .special:
                    signUpPageView.passwordTextField.infoCommandLabel.text = "비밀번호는 특수문자를 포함되어야 합니다."
                    signUpPageView.passwordTextField.infoCommandLabel.textColor = .systemRed
                case .right:
                    signUpPageView.passwordTextField.infoCommandLabel.text = "사용가능한 비밀번호 입니다."
                    signUpPageView.passwordTextField.infoCommandLabel.textColor = .systemBlue
                }
            }
            viewModel.checkPassword.value = viewModel.checkPassword.value
            isPossibleSingUp()
        }
        
        viewModel.checkPassword.bind { [weak self] password in
            guard let self = self else { return }
            if password == "" {
                signUpPageView.checkPasswordTextField.infoCommandLabel.text = ""
            } else {
                if password == viewModel.password.value {
                    signUpPageView.checkPasswordTextField.infoCommandLabel.text = "비밀번호가 일치합니다."
                    signUpPageView.checkPasswordTextField.infoCommandLabel.textColor = .systemBlue
                } else {
                    signUpPageView.checkPasswordTextField.infoCommandLabel.text = "비밀번호가 일치하지 않습니다."
                    signUpPageView.checkPasswordTextField.infoCommandLabel.textColor = .systemRed
                }
            }
            isPossibleSingUp()
        }
    }
}

extension SignUpPageViewController {
    // MARK: - Method
    
    @objc func didTapButton(_ sender: UIButton) {
        
        switch sender {
        case signUpPageView.linkButton:
            let privacyPolicyVC = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
            tabBarController?.tabBar.isHidden = true
        case signUpPageView.privacyPolicyButton:
            sender.isSelected.toggle()
            if sender.isSelected {
                let checkboxImage = UIImage(systemName: "checkmark.square")
                sender.setImage(checkboxImage, for: .normal)
            } else {
                let checkboxImage = UIImage(systemName: "square")
                sender.setImage(checkboxImage, for: .normal)
            }
            isPossibleSingUp()
        default:
            print("[SignUpPageViewController]:\(#function):This button is not registered.")
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
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // nickName 유효성 검사
    func isValidNickName(nickName: String) -> Bool {
        return (2 ... 8).contains(nickName.count)
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
                self.signUpPageView.registerButton.changeTitleColor(color: .white)
                self.signUpPageView.registerButton.changeButtonColor(color: .black)
                self.signUpPageView.registerButton.setButtonEnabled(true)
            } else {
                self.signUpPageView.registerButton.changeTitleColor(color: .label)
                self.signUpPageView.registerButton.changeButtonColor(color: .systemGray4)
                self.signUpPageView.registerButton.setButtonEnabled(false)
            }
        }
    }
    
    func isPossibleSingUp() {
        guard let emailText = signUpPageView.emailTextField.infoCommandLabel.text,
              let nickNameText = signUpPageView.nicknameTextField.infoCommandLabel.text,
              let passwordText = signUpPageView.passwordTextField.infoCommandLabel.text,
              let checkPasswordText = signUpPageView.checkPasswordTextField.infoCommandLabel.text else { return }
        let isPrivacyPolicySelected = signUpPageView.privacyPolicyButton.isSelected
        
        if emailText == "사용가능한 이메일 입니다.",
           nickNameText == "사용가능한 닉네임 입니다.",
           passwordText == "사용가능한 비밀번호 입니다.",
           checkPasswordText == "비밀번호가 일치합니다.",
           isPrivacyPolicySelected
        {
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
        viewModel.loginManager.trySignUp(email: viewModel.email.value, password: viewModel.password.value, nickName: viewModel.nickName.value) { [weak self] result in
            guard let self = self else { return }
            if result.isSuccess {
                print("Create User")
                let alert = UIAlertController(title: "회원가입 완료", message: "확인을 누르면 로그인 화면으로 돌아 갑니다.", preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yes)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "회원가입 실패", message: result.errorMessage, preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yes)
                self.present(alert, animated: true)
            }
        }
        
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 'convert(_:to:)' 함수를 사용하여 'checkPasswordTextField'의 하단 경계를 현재 뷰의 좌표계로 변환
            // 'maxY'는 변환된 좌표계에서 텍스트 필드의 최하단 y값
            let bottomOfTextField = signUpPageView.checkPasswordTextField.convert(signUpPageView.checkPasswordTextField.bounds, to: view).maxY
            // 화면의 높이에서 키보드 높이를 빼서 키보드의 상단 위치를 계산
            let topOfKeyboard = view.frame.height - keyboardSize.height
            let spacing: CGFloat = 10 // 키보드와 checkPasswordTextField 사이의 원하는 간격
            
            // 키보드가 checkPasswordTextField를 가리는 경우 뷰를 올림
            // 텍스트 필드의 하단이 키보드의 상단보다 아래에 위치한다면
            if bottomOfTextField > topOfKeyboard {
                // 텍스트 필드 하단과 키보드 상단 사이의 거리에 원하는 간격을 더한 값을 계산
                let offset = bottomOfTextField + spacing - topOfKeyboard
                // 현재 뷰의 y축 원점 위치를 이동시켜서 텍스트 필드가 키보드에 가리지 않도록 함
                // offset만큼 위로 올라가도록 음수 값을 사용
                view.frame.origin.y = -offset
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 뷰를 원래 위치로 되돌림
        if view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0
            }
        }
    }
}

extension SignUpPageViewController: CommandLabelDelegate {
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case signUpPageView.emailTextField.inputTextField:
            viewModel.email.value = text
        case signUpPageView.nicknameTextField.inputTextField:
            viewModel.nickName.value = text
        case signUpPageView.passwordTextField.inputTextField:
            viewModel.password.value = text
        case signUpPageView.checkPasswordTextField.inputTextField:
            viewModel.checkPassword.value = text
        default:
            print("등록되지 않은 텍스트 필드")
        }
    }
}
