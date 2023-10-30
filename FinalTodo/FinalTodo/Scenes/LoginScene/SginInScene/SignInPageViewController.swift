//
//  SignInPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

// TODO: - Font -> 지정 폰트로 변경
// TODO: - 공용뷰로 작업.
// TODO: - AutoLayout은 상수 x 화면 비율로 계산
// TODO: - 들여쓰기

// 로그인페이지
class SignInPageViewController: UIViewController, CommandLabelDelegate {
    // 맨위에 로그인 굵은글자
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()

    let loginBar = CommandLabelView(title: "아이디", placeholder: "아이디를 입력해주세요.", isSecureTextEntry: false)
    let passwordBar = CommandLabelView(title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", isSecureTextEntry: true)
    let loginButton = ButtonTappedView(title: "로그인")
    let haveAccountButton = ButtonTappedView(title: "가입이 필요하신가요?")

    private let viewModel = SignInPageViewModel()
}

extension SignInPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loginBar.delegate = self
        passwordBar.delegate = self
        loginButton.delegate = self
        haveAccountButton.delegate = self
        view.backgroundColor = .systemBackground
        isLoginAble(state: false)
        haveAccountButton.changeButtonColor(color: .systemBackground)
        haveAccountButton.changeTitleColor(color: .secondaryLabel)
        setUp()
        bind()
       
    }
}

private extension SignInPageViewController {
    // MARK: - SetUp

    
    func bind() {
        viewModel.email.bind { [weak self] email in
            guard let self = self else { return }
            if !viewModel.password.value.isEmpty && !email.isEmpty {
                isLoginAble(state: true)
            } else {
                isLoginAble(state: false)
            }
        }
        
        viewModel.password.bind { [weak self] password in
            guard let self = self else { return }
            if !viewModel.email.value.isEmpty && !password.isEmpty {
                isLoginAble(state: true)
            } else {
                isLoginAble(state: false)
            }
        }
    }
    
    
    func setUp() {
        setUpUserName()
        setUpPasswordName()
        setUpButton()
        
    }

    func setUpUserName() {
        view.addSubview(loginLabel)
        // 맨위 로그인레이블 오토레이아웃
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.07)
            make.leading.equalTo(Constant.defaultPadding)
        }

        view.addSubview(loginBar)
        // 로그인텍스트
        loginBar.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    func setUpPasswordName() {
        view.addSubview(passwordBar)
        // 패스워드 텍스트
        passwordBar.snp.makeConstraints { make in
            make.top.equalTo(loginBar.snp.bottom).offset(Constant.screenHeight * 0.03)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    func setUpButton() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordBar.snp.bottom).offset(Constant.screenHeight * 0.09)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }

        view.addSubview(haveAccountButton)
        haveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
}

extension SignInPageViewController {
    // MARK: - Method

    
    func isLoginAble(state: Bool) {
        UIView.animate(withDuration: 0.3) {
            if state {
                self.loginButton.changeTitleColor(color: .systemGray4)
                self.loginButton.changeButtonColor(color: .secondaryLabel)
                self.loginButton.setButtonEnabled(true)
            } else {
                self.loginButton.changeTitleColor(color: .label)
                self.loginButton.changeButtonColor(color: .secondarySystemBackground)
                self.loginButton.setButtonEnabled(false)
            }
        }
    }
    // 빈곳 누르면 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc func textFieldEditingChanged(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if text.count == 1 {
            if text == " " {
                textField.text = ""
                return
            }
        }
        
        switch textField {
        case loginBar.inputTextField:
            viewModel.email.value = text
        case passwordBar.inputTextField:
            viewModel.password.value = text
        default:
            print("Unregistered text field")
        }
    }
}

extension SignInPageViewController: ButtonTappedViewDelegate {
    func didTapButton(button: UIButton) {

        switch button {
        case loginButton.anyButton:
            viewModel.loginManager.trySignIn(email: viewModel.email.value, password: viewModel.password.value) { loginResult in
                if loginResult.isSuccess {
                    let rootView = TabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: rootView, animated: false)
                } else {
//                    print("LoginFail")
//                    let alert = UIAlertController(title: "오류", message: "이메일 혹은 비밀번호를 잘못 입력하셨거나 등록되지 않은 이메일 입니다.", preferredStyle: .alert)
//                    let yes = UIAlertAction(title: "확인", style: .cancel)
//                    alert.addAction(yes)
//                    self.present(alert, animated: true)
                    self.loginBar.shake()
                    self.passwordBar.shake()
                }
            }
        case haveAccountButton.anyButton:
            let vc = SignUpPageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Unregistered button")
        }
        

//        // 서령: 로그인 버튼 클릭 시 씬델리게이트의 루트뷰 컨트롤러 탭바로 변경
//        let tabbar = TabBarController()
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: tabbar, animated: true)
    }
}
