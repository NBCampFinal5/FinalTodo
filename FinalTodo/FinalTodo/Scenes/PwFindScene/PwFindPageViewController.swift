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
    
    let nameView = {
        InputFieldView(title: "아이디")
    }
    let callNumView = {
        InputFieldView(title: "휴대전화 번호")
    }
    let sendMsButtonView = {
        buttonTappedView(title: "인증번호 받기")
    }
    
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
}
extension PwFindPageViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
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

        
    }
    func setupPhoneNumber(){
        

    }
    func setupEnterNumber(){
       
        
    }
}

