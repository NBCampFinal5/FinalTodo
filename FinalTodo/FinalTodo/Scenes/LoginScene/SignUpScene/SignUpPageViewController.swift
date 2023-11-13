//
//  SignUpPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

final class SignUpPageViewController: BasicViewController<SignUpPageViewModel, SignUpPageView> {
    // MARK: - Property
//    var viewModel: SignUpPageViewModel?
//    private let signUpPageView = SignUpPageView()
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
        self.navigationController?.navigationBar.tintColor = .label
        setUpSignUpPageView()
        setUpDelegate()
        setUpKeyBoardNotify()
    }
    
    func setUpSignUpPageView() {
        self.view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        customView.linkButton.addTarget(self, action: #selector(didTapLinkButton), for: .touchUpInside)
        customView.privacyPolicyButton.addTarget(self, action: #selector(didTapPrivacyButton(_:)), for: .touchUpInside)
        customView.registerButton.anyButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    func setUpDelegate() {
        customView.emailTextField.delegate = self
        customView.nicknameTextField.delegate = self
        customView.passwordTextField.delegate = self
        customView.checkPasswordTextField.delegate = self
    }
    
    func setUpKeyBoardNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

private extension SignUpPageViewController {
    // MARK: - Bind
    
    func bind() {
        bindEmail()
        bindNickName()
        bindPassword()
        bindCheckPassword()
        bindIsSignUpAble()
        bindIsPrivacyAgree()
    }
    
    func bindEmail() {
        viewModel?.emailState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                customView.emailTextField.infoCommandLabel.text = ""
            case .alreadyInUse:
                customView.emailTextField.infoCommandLabel.text = "이미 사용중인 이메일 입니다."
                customView.emailTextField.infoCommandLabel.textColor = .systemRed
            case .available:
                customView.emailTextField.infoCommandLabel.text = "사용가능한 이메일 입니다."
                customView.emailTextField.infoCommandLabel.textColor = .systemBlue
            case .unavailableFormat:
                customView.emailTextField.infoCommandLabel.text = "이메일 주소를 정확히 입력해주세요."
                customView.emailTextField.infoCommandLabel.textColor = .systemRed
            case .checking:
                customView.emailTextField.infoCommandLabel.text = "사용 가능여부 조회중"
                customView.emailTextField.infoCommandLabel.textColor = .systemGray
            }
            viewModel?.isPossibleSingUp()
        }
        
        viewModel?.email.bind { [weak self] email in
            guard let self = self else { return }
            viewModel?.isValidEmail(email: email)
        }
    }
    
    func bindNickName() {
        viewModel?.nickNameState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                customView.nicknameTextField.infoCommandLabel.text = ""
            case .length:
                customView.nicknameTextField.infoCommandLabel.text = "2글자에서 8글자 사이의 닉네임을 입력해주세요."
                customView.nicknameTextField.infoCommandLabel.textColor = .systemRed
            case .available:
                customView.nicknameTextField.infoCommandLabel.text = "사용가능한 닉네임 입니다."
                customView.nicknameTextField.infoCommandLabel.textColor = .systemBlue
            }
            viewModel?.isPossibleSingUp()
        }
        
        viewModel?.nickName.bind { [weak self] nickName in
            guard let self = self else { return }
            viewModel?.isValidNickName(nickName: nickName)
        }
    }
    
    func bindPassword() {
        viewModel?.passwordState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                customView.passwordTextField.infoCommandLabel.text = ""
            case .length:
                customView.passwordTextField.infoCommandLabel.text = "8글자에서 20자 사이의 비밀번호를 입력해주세요."
                customView.passwordTextField.infoCommandLabel.textColor = .systemRed
            case .combination:
                customView.passwordTextField.infoCommandLabel.text = "비밀번호는 숫자, 영문, 특수문자를 조합하여야 합니다."
                customView.passwordTextField.infoCommandLabel.textColor = .systemRed
            case .special:
                customView.passwordTextField.infoCommandLabel.text = "비밀번호는 특수문자를 포함되어야 합니다."
                customView.passwordTextField.infoCommandLabel.textColor = .systemRed
            case .available:
                customView.passwordTextField.infoCommandLabel.text = "사용가능한 비밀번호 입니다."
                customView.passwordTextField.infoCommandLabel.textColor = .systemBlue
            }
            viewModel?.isPossibleSingUp()
        }
        
        viewModel?.password.bind { [weak self] password in
            guard let self = self else { return }
            viewModel?.isValidPassword(password: password)
            guard let checkPassword = customView.checkPasswordTextField.inputTextField.text else { return }
            viewModel?.isCheckPassword(password: checkPassword)
        }
    }
    
    func bindCheckPassword() {
        viewModel?.checkPasswordState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                customView.checkPasswordTextField.infoCommandLabel.text = ""
            case .available:
                customView.checkPasswordTextField.infoCommandLabel.text = "비밀번호가 일치합니다."
                customView.checkPasswordTextField.infoCommandLabel.textColor = .systemBlue
            case .unconformity:
                customView.checkPasswordTextField.infoCommandLabel.text = "비밀번호가 일치하지 않습니다."
                customView.checkPasswordTextField.infoCommandLabel.textColor = .systemRed
            }
            viewModel?.isPossibleSingUp()
        }
        
        viewModel?.checkPassword.bind { [weak self] password in
            guard let self = self else { return }
            viewModel?.isCheckPassword(password: password)
        }
    }
    
    func bindIsSignUpAble() {
        viewModel?.isSignUpAble.bind { [weak self] state in
            guard let self = self else { return }
            isSignUpAble(state: state)
        }
    }
    
    func bindIsPrivacyAgree() {
        viewModel?.isPrivacyAgree.bind { [weak self] state in
            guard let self = self else { return }
            if state {
                customView.privacyPolicyButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                customView.privacyPolicyButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
            viewModel?.isPossibleSingUp()
        }
    }
}

extension SignUpPageViewController {
    // MARK: - Method
    @objc func didTapLinkButton() {
        let privacyPolicyVC = PrivacyPolicyViewController()
        navigationController?.pushViewController(privacyPolicyVC, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func didTapPrivacyButton(_ sender: UIButton) {
        viewModel?.isPrivacyAgree.value.toggle()
    }
    
    @objc func didTapRegisterButton() {
        guard let viewModel = viewModel else { return }
        viewModel.loginManager.trySignUp(email: viewModel.email.value, password: viewModel.password.value, nickName: viewModel.nickName.value
        ) { [weak self] result in
            guard let self = self else { return }
            let alert: UIAlertController
            if result.isSuccess {
                alert = UIAlertController(title: "회원가입 완료", message: "확인을 누르면 로그인 화면으로 돌아 갑니다.", preferredStyle: .alert)
            } else {
                alert = UIAlertController(title: "회원가입 실패", message: result.errorMessage, preferredStyle: .alert)
            }
            let yes = UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(yes)
            self.present(alert, animated: true)
        }
    }

    func isSignUpAble(state: Bool) {
        UIView.animate(withDuration: 0.3) {
            if state {
                if UITraitCollection.current.userInterfaceStyle == .light {
                    self.customView.registerButton.changeButtonColor(color: .black)
                    self.customView.registerButton.changeTitleColor(color: .white)
                } else {
                    self.customView.registerButton.changeButtonColor(color: .white)
                    self.customView.registerButton.changeTitleColor(color: .black)
                }
                self.customView.registerButton.setButtonEnabled(true)
            } else {
                self.customView.registerButton.changeTitleColor(color: .label)
                self.customView.registerButton.changeButtonColor(color: .systemGray4)
                self.customView.registerButton.setButtonEnabled(false)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 'convert(_:to:)' 함수를 사용하여 'checkPasswordTextField'의 하단 경계를 현재 뷰의 좌표계로 변환
            // 'maxY'는 변환된 좌표계에서 텍스트 필드의 최하단 y값
            let bottomOfTextField = customView.checkPasswordTextField.convert(customView.checkPasswordTextField.bounds, to: view).maxY
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

//extension SignUpPageViewController: ViewModelInjectable {
//    
//    func injectViewModel(_ viewModelType: SignUpPageViewModel) {
//        self.viewModel = viewModelType
//    }
//}

extension SignUpPageViewController: CommandLabelDelegate {
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case customView.emailTextField.inputTextField:
            viewModel?.email.value = text
        case customView.nicknameTextField.inputTextField:
            viewModel?.nickName.value = text
        case customView.passwordTextField.inputTextField:
            viewModel?.password.value = text
        case customView.checkPasswordTextField.inputTextField:
            viewModel?.checkPassword.value = text
        default:
            print("등록되지 않은 텍스트 필드")
        }
    }
}
