//
//  PwFindPageViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import UIKit

class PwFindPageViewController: UIViewController {
    
    //맨위에 설명할수있는 글자 아무거나 ex) 로그인,,비밀번호찾기.. 등등
    private lazy var findPwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 찾기"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    //작은 레이블, 입력필드 위에 설명할수 있는 무언가 적을 수 있는 레이블
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        return label
    }()
    //텍스트뷰
    private lazy var idTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor03")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //입력바(입력받을수있는 공간..)
    private lazy var idITextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor02")
        tf.textColor = UIColor(named: "theme01PointColor01")
        tf.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해주세요.", attributes : [NSAttributedString.Key.foregroundColor: "theme01PointColor02"])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    //작은 레이블, 입력필드 위에 설명할수 있는 무언가 적을 수 있는 레이블
    private lazy var callNumLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화 번호"
        return label
    }()
    //텍스트뷰
    private lazy var callNumTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor03")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //입력바(입력받을수있는 공간..)
    private lazy var callNUmTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor02")
        tf.textColor = UIColor(named: "theme01PointColor01")
        tf.attributedPlaceholder = NSAttributedString(string: "010-0000-0000", attributes : [NSAttributedString.Key.foregroundColor: "theme01PointColor02"])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    
    //버튼
    private lazy var sendMsButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "theme01PointColor01")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("인증번호 받기", for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        // button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //작은 레이블, 입력필드 위에 설명할수 있는 무언가 적을 수 있는 레이블
    private lazy var enterNumLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호를 적어주세요"
        return label
    }()
    //텍스트뷰
    private lazy var numTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor03")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //입력바(입력받을수있는 공간..)
    private lazy var numTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor02")
        tf.textColor = UIColor(named: "theme01PointColor01")
        tf.attributedPlaceholder = NSAttributedString(string: "• • • • • • • •", attributes : [NSAttributedString.Key.foregroundColor: "theme01PointColor02"])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    
    //버튼
    private lazy var findPwButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "theme01PointColor01")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("비밀번호 찾기", for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        // button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        // MARK: - LifeCycle
        super.viewDidLoad()
        setup()
    }
}

private extension LoginView {
    func setup(){
        // MARK: - setup
        setupInputName()
        setupPhoneNumber()
        setupEnterNumber()
    }
    //오토레이아웃
    
    func setupInputName(){
        self.addSubview(findPwLabel)
        //맨위 큰레이블 오토레이아웃
        findPwLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.07)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
        self.addSubview(idLabel)
        //작은레이블 오토레이아웃
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(pwFindLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
        self.addSubview(idTextFieldView)
        //필드뷰(네모박스)오토레이아웃
        commandTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(self.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        self.addSubview(idTextField)
        //텍스트필드 오토레이아웃
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(idLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
    func setupPhoneNumber(){
        
        self.addSubview(idTextFieldView)
        //필드뷰(네모박스)오토레이아웃
        commandTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(self.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        self.addSubview(idTextField)
        //텍스트필드 오토레이아웃
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(idLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    func setupEnterNumber(){
        self.addSubview(sendMsButton)
        anyButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(Constant.screenHeight * 0.09)
            make.centerX.equalTo(inputTextField.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
}

