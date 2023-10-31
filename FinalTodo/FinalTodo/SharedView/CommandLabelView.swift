//
//  commandLableView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/17/23.
//

import UIKit
import SnapKit

class CommandLabelView: UIView {
    weak var delegate: CommandLabelDelegate?
    //작은 레이블, 입력필드 위에 설명할수 있는 무언가 적을 수 있는 레이블
    private lazy var commandLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let infoCommandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    //입력바(입력받을수있는 공간..)
    lazy var inputTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .secondarySystemBackground
        tf.tintColor = .label
        tf.textColor = .label
        tf.font = UIFont.preferredFont(forTextStyle: .headline)
        tf.layer.cornerRadius = 5
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        return tf
    }()
    
    
    init(title: String, placeholder: String, isSecureTextEntry : Bool) {
        super.init(frame: CGRect.zero)
        self.commandLabel.text = title
        self.inputTextField.placeholder = placeholder
        self.inputTextField.isSecureTextEntry = isSecureTextEntry
        paddingView()
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension CommandLabelView {
    
    func setup(){
        setupLabelName()
        setupTextField()
    }
    //오토레이아웃
    
    func setupLabelName(){
        self.addSubview(commandLabel)
        //맨위 레이블 오토레이아웃
        commandLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(Constant.defaultPadding)
        }
        
    }
    func setupTextField(){
        self.addSubview(inputTextField)
        //텍스트필드 오토레이아웃
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(commandLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
            make.bottom.equalToSuperview()
        }
    }
    
    func paddingView(){
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        inputTextField.leftView = leftPaddingView
        inputTextField.leftViewMode = .always
    }
}

extension CommandLabelView {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        // 이 함수를 델리게이트 메서드로 호출
        delegate?.textFieldEditingChanged(textField)
    }
}

extension CommandLabelView {
    func addInfoLabel() {
        self.addSubview(infoCommandLabel)
        infoCommandLabel.snp.makeConstraints { make in
            make.left.equalTo(commandLabel.snp.right).offset(Constant.defaultPadding)
            make.centerY.equalTo(commandLabel.snp.centerY)
        }
    }
}
