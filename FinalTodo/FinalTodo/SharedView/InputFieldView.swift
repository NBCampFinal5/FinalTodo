//
//  InputFieldView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/17/23.
//

import UIKit
import SnapKit

class InputFieldView : UIView {
    //유저네임 레이블
    private lazy var loginTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        return label
    }()
    //로그인텍스트뷰(첫번째 검은상자)
    private lazy var loginTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor03")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //아이디 입력바
    private lazy var loginTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor01")
        tf.textColor = UIColor(named: "theme01PointColor01")
//        tf.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해주세요", attributes : [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8750917912, green: 0.9150126576, blue: 0.7795882821, alpha: 1)])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        setupLoginField()
    }
    
    func setupLoginField(){
        self.addSubview(loginTextLabel)
        //로그인텍스트
        loginTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(Constant.defaultPadding)
        }
        
        self.addSubview(loginTextFieldView)
        //로그인텍스트필드뷰(네모박스
        loginTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(loginTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(self.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        self.addSubview(loginTextField)
        //로그인텍스트필드
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(loginTextFieldView.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
}
