//
//  PwFindPageViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import UIKit
import SnapKit

class PwFindPageViewController: UIViewController {
    
    //맨위에 설명할수있는 글자 아무거나 ex) 로그인,,비밀번호찾기.. 등등
    private lazy var findPwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 찾기"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    
    let idLabel = commandLabelView() //아이디
    let callNumber = commandLabelView() //전화번호
    let requestButton = buttonTappedView() //인증번호받기
    let inputLabel = commandLabelView() //인증번호입력
    let findPwButton = buttonTappedView() //패스워드 찾기
    
    
    override func viewDidLoad() {
        // MARK: - LifeCycle
        super.viewDidLoad()
        setup()
    }
}

private extension PwFindPageViewController {
    // MARK: - setup
    func setup(){
        setupInputName()
        setupPhoneNumber()
        setupEnterNumber()
    }
    //오토레이아웃
    
    func setupInputName(){
        view.addSubview(findPwLabel)
        //맨위 큰레이블 오토레이아웃
        findPwLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.07)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
        view.addSubview(idLabel)
        //작은레이블 오토레이아웃
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(findPwLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.leading.equalTo(Constant.defaultPadding)
        }
        
    }
    func setupPhoneNumber(){
        
        view.addSubview(callNumber)
        //필드뷰(네모박스)오토레이아웃
        commandTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        view.addSubview(requestButton)
        //텍스트필드 오토레이아웃
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalTo(idLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding + 10)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    func setupEnterNumber(){
        view.addSubview(inputLabel)
        anyButton.snp.makeConstraints { make in
            make.top.equalTo(requestButton.snp.bottom).offset(Constant.screenHeight * 0.09)
            make.centerX.equalTo(inputTextField.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        view.addSubview(findPwButton)
        anyButton.snp.makeConstraints { make in
            make.top.equalTo(inputLabel.snp.bottom).offset(Constant.screenHeight * 0.09)
            make.centerX.equalTo(inputTextField.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
}

