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

    lazy var activityIndicator: UIActivityIndicatorView = {
        // 해당 클로저에서 나중에 indicator 를 반환해주기 위해 상수형태로 선언
        let activityIndicator = UIActivityIndicatorView()

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        activityIndicator.center = self.view.center

        // 기타 옵션
        activityIndicator.color = .secondaryLabel
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium

        // stopAnimating을 걸어주는 이유는, 최초에 해당 indicator가 선언되었을 때, 멈춘 상태로 있기 위해서
        activityIndicator.stopAnimating()

        return activityIndicator

    }()

    let loginBar = CommandLabelView(title: "아이디", placeholder: "아이디를 입력해주세요.", isSecureTextEntry: false)
    let passwordBar = CommandLabelView(title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", isSecureTextEntry: true)
    let loginButton = ButtonTappedView(title: "로그인")
    let loginInfoLabel: UILabel = {
        let view = UILabel()
        view.text = "이메일 혹은 비밀번호를 잘못 입력하셨거나 등록되지 않은 이메일 입니다."
        view.textColor = .systemRed
        view.numberOfLines = 0
        view.font = .preferredFont(forTextStyle: .footnote)
        view.alpha = 0
        return view
    }()

    let haveAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        return button
    }()

    let passwordFindButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        return button
    }()

    lazy var autoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("자동 로그인", for: .normal)
        if viewModel.userDefaultManager.getIsAutoLogin() {
            button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "square"), for: .normal)
        }
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)

        return button
    }()

    private let viewModel = SignInPageViewModel()

    private let coredataManager = CoreDataManager.shared
}

extension SignInPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loginButton.changeButtonColor(color: .secondarySystemBackground)
        setUpDelegate()
        setUp()
        bind()
        print("@@, \(CoreDataManager.shared.getUser().themeColor)")
    }
    

}

private extension SignInPageViewController {
    // MARK: - SetUp

    func setUpDelegate() {
        loginBar.delegate = self
        passwordBar.delegate = self
        loginButton.delegate = self
    }

    func bind() {
        viewModel.email.bind { [weak self] email in
            guard let self = self else { return }
            self.showMissMatchMassage(state: false)
            if !viewModel.password.value.isEmpty, !email.isEmpty {
                isLoginAble(state: true)
            } else {
                isLoginAble(state: false)
            }
        }

        viewModel.password.bind { [weak self] password in
            guard let self = self else { return }
            self.showMissMatchMassage(state: false)
            if !viewModel.email.value.isEmpty, !password.isEmpty {
                isLoginAble(state: true)
            } else {
                isLoginAble(state: false)
            }
        }
    }

    func setUp() {
        setUpUserName()
        setUpPasswordName()
        setUpLoginInfoLabel()
        setUpButton()
        view.addSubview(activityIndicator)
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

    func setUpLoginInfoLabel() {
        view.addSubview(loginInfoLabel)
        loginInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordBar.snp.bottom)
            make.left.right.equalTo(passwordBar).inset(Constant.defaultPadding)
        }
    }

    func setUpButton() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordBar.snp.bottom).offset(Constant.screenHeight * 0.055)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }

        view.addSubview(passwordFindButton)
        passwordFindButton.addTarget(self, action: #selector(didTapPasswordFindButton), for: .touchUpInside)
        passwordFindButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(Constant.defaultPadding)
            make.right.equalTo(loginButton.snp.right).inset(Constant.defaultPadding)
        }

        view.addSubview(haveAccountButton)
        haveAccountButton.addTarget(self, action: #selector(didTapSignUpbutton), for: .touchUpInside)
        haveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(Constant.defaultPadding)
            make.right.equalTo(passwordFindButton.snp.left).offset(-Constant.defaultPadding)
        }

        view.addSubview(autoLoginButton)
        autoLoginButton.addTarget(self, action: #selector(didTapAutoLoginButton), for: .touchUpInside)
        autoLoginButton.snp.makeConstraints { make in
            make.centerY.equalTo(haveAccountButton.snp.centerY)
            make.left.equalTo(loginButton.snp.left).inset(Constant.defaultPadding)
        }
    }
}

extension SignInPageViewController {
    // MARK: - Method

    func isLoginAble(state: Bool) {
        UIView.animate(withDuration: 0.3) {
            if UITraitCollection.current.userInterfaceStyle == .light {
                if state {
                    self.loginButton.changeTitleColor(color: .white)
                    self.loginButton.changeButtonColor(color: .black)
                    self.loginButton.setButtonEnabled(true)
                } else {
                    self.loginButton.changeTitleColor(color: .white)
                    self.loginButton.changeButtonColor(color: .systemGray3)
                    self.loginButton.setButtonEnabled(false)
                }
            } else {
                if state {
                    self.loginButton.changeTitleColor(color: .black)
                    self.loginButton.changeButtonColor(color: .white)
                    self.loginButton.setButtonEnabled(true)
                } else {
                    self.loginButton.changeTitleColor(color: .white)
                    self.loginButton.changeButtonColor(color: .systemGray3)
                    self.loginButton.setButtonEnabled(false)
                }
            }

        }
    }

    func showMissMatchMassage(state: Bool) {
        UIView.animate(withDuration: 0.3) {
            if state {
                self.loginInfoLabel.alpha = 1
            } else {
                self.loginInfoLabel.alpha = 0
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

    @objc func didTapSignUpbutton() {
        let vc = SignUpPageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapPasswordFindButton() {
        let alert = UIAlertController(title: "비밀번호 재설정", message: "입력하신 이메일로 재설정 메일을 발송합니다.", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let yes = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let email = alert.textFields?[0].text else { return }
            guard let self = self else { return }
            self.viewModel.loginManager.passwordFind(email: email)
        }
        alert.addTextField()
        alert.textFields?[0].placeholder = "example@example.com"
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    @objc func didTapAutoLoginButton() {
        if viewModel.userDefaultManager.getIsAutoLogin() {
            viewModel.userDefaultManager.setAutoLogin(toggle: false)
            autoLoginButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            viewModel.userDefaultManager.setAutoLogin(toggle: true)
            autoLoginButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
}

extension SignInPageViewController: ButtonTappedViewDelegate {
    func didTapButton(button: UIButton) {
        switch button {
        case loginButton.anyButton:
            activityIndicator.startAnimating()
            viewModel.loginManager.trySignIn(email: viewModel.email.value, password: viewModel.password.value) { loginResult in
                if loginResult.isSuccess {
                    self.activityIndicator.stopAnimating()
                    print("@@, \(CoreDataManager.shared.getUser().themeColor)")
                    UIColor.myPointColor = UIColor(hex: CoreDataManager.shared.getUser().themeColor)
                    let rootView = TabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: rootView, animated: false)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.showMissMatchMassage(state: true)
                    self.loginBar.shake()
                    self.passwordBar.shake()
                }
            }
        default:
            print("Unregistered button")
        }
    }
}
