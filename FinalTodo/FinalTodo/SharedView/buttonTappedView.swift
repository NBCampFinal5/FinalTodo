//
//  LoginView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import UIKit
import SnapKit

class buttonTappedView: UIView {

    //작은 레이블, 입력필드 위에 설명할수 있는 무언가 적을 수 있는 레이블
    private lazy var commandLabel: UILabel = {
        let label = UILabel()
        label.text = "아무거나 적기"
        return label
    }()
    //텍스트뷰
    private lazy var commandTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor03")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //입력바(입력받을수있는 공간..)
    private lazy var inputTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = UIColor(named: "theme01PointColor02")
        tf.textColor = UIColor(named: "theme01PointColor01")
        tf.attributedPlaceholder = NSAttributedString(string: "틴트텍스트", attributes : [NSAttributedString.Key.foregroundColor: "theme01PointColor02"])
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    
    //버튼
    private lazy var anyButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "theme01PointColor01")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("버튼이름쓰세용", for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
       // button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
        
    init(title: String) {
        super.init(frame: CGRect.zero)
        commandLabel.text = "title"
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
private extension buttonTappedView {
    func setup(){
        setupLableName()
        setupTextField()
        setupButton()
    }
    //오토레이아웃

    func setupLableName(){
        self.addSubview(commandLabel)
        //맨위 레이블 오토레이아웃
        commandLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.07)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
    }
    func setupTextField(){
        self.addSubview(commandTextFieldView)
        //필드뷰(네모박스)오토레이아웃
        commandTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(commandLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(self.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        self.addSubview(inputTextField)
        //텍스트필드 오토레이아웃
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(commandLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(commandLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
        func setupButton(){
            self.addSubview(anyButton)
            anyButton.snp.makeConstraints { make in
                make.top.equalTo(inputTextField.snp.bottom).offset(Constant.screenHeight * 0.09)
                make.centerX.equalTo(inputTextField.snp.left)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
                make.height.equalTo(Constant.screenHeight * 0.05)
            }

            }
        }



