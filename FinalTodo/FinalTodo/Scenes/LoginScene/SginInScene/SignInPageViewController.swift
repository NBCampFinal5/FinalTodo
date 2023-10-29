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

//    private let viewModel = SignInPageViewModel()
}

extension SignInPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loginBar.delegate = self
        passwordBar.delegate = self
        loginButton.delegate = self
        haveAccountButton.delegate = self
        view.backgroundColor = .white
        haveAccountButton.changeButtonColor(color: .systemBackground)
        haveAccountButton.changeTitleColor(color: .secondaryLabel)
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

    // 빈곳 누르면 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let id = loginBar.inputTextField.text, !id.isEmpty,
            let password = passwordBar.inputTextField.text, !password.isEmpty
        else {
            loginButton.backgroundColor = .systemFill
            loginButton.setButtonEnabled(false)
            return
        }
        loginButton.changeButtonColor(color: .secondarySystemFill)
        loginButton.setButtonEnabled(true)
    }

    // 로그인버튼 누르면 다음화면으로 넘어가는 것 구현
    @objc func didTapButton() {}
}

extension SignInPageViewController: ButtonTappedViewDelegate {
    func didTapButton(button: UIButton) {
//        guard let email = loginBar.inputTextField.text else { return }
//        guard let password = passwordBar.inputTextField.text else { return }
//        viewModel.loginManager.trySignIn(email: email, password: password) { loginResult in
//            if loginResult.isSuccess {
//                let rootView = TabBarController()
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: rootView, animated: false)
//            } else {
//                print("LoginFail")
//            }
//        }

        // 서령: 로그인 버튼 클릭 시 씬델리게이트의 루트뷰 컨트롤러 탭바로 변경
        let tabbar = TabBarController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: tabbar, animated: true)
    }
}
