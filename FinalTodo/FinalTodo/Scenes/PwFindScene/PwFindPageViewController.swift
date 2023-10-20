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
    
    

    

    let idLabel = CommandLabelView(title: "아이디", placeholder: "아이디를 입력해주세요.") //아이디
    let callNumber = CommandLabelView(title: "휴대전화 번호", placeholder: "010-0000-0000") //전화번호
    let requestButton = ButtonTappedView(title: "인증번호 받기") //인증번호받기
    let inputLabel = CommandLabelView(title: "인증번호 입력", placeholder: "인증번호를 입력해주세요.") //인증번호입력
    let findPwButton = ButtonTappedView(title: "비밀번호 찾기") //패스워드 찾기


    
    override func viewDidLoad() {
        // MARK: - LifeCycle
        super.viewDidLoad()
        setup()
    }
}

private extension PwFindPageViewController {
    // MARK: - setup
    func setup(){
        view.backgroundColor = UIColor(named: "theme01PointColor02")
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
        //아이디박스
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(findPwLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(Constant.screenHeight * 0.05)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }
        
    }
    func setupPhoneNumber(){
        
        view.addSubview(callNumber)
        //전화번호 박스
        callNumber.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        view.addSubview(requestButton)
        //인증번호버튼
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(callNumber.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.centerX.equalTo(idLabel.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    func setupEnterNumber(){
        view.addSubview(inputLabel)
        //인증번호적기 박스
        inputLabel.snp.makeConstraints { make in
            make.top.equalTo(requestButton.snp.bottom).offset(Constant.screenHeight * 0.09)
            make.centerX.equalTo(requestButton.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        view.addSubview(findPwButton)
        //비밀번호찾기버튼
        findPwButton.snp.makeConstraints { make in
            make.top.equalTo(inputLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.centerX.equalTo(requestButton.snp.left)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
}


