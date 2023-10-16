//
//  PwFindViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/12/23.
//

import UIKit

class PwFindViewController: UIViewController {

    //맨위에 굵은글자
    private lazy var pwFindLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 찾기"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    //아이디 레이블
    private lazy var idTextLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        return label
    }()
    //아이디텍스트뷰(첫번째 검은상자)
    private lazy var idTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //아이디 입력바
    private lazy var idTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = .white
        tf.textColor = .white
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
       // tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
       
    
    private lazy var loginTextLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화 번호"
        return label
    }()
    //폰넘버(두번째 검은상자)
    private lazy var phoneNumberTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //폰넘버 입력바
    private lazy var phoneNumberTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = .white
        tf.textColor = .white
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    //매세지 요청 버튼
    private lazy var requestMsButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4777786732, green: 0.50278157, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("인증번호 요청하기", for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        //button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
 
    //인증번호(세번째 검은상자)
    private lazy var cetificationNumberTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    //인증번호입력바
    private lazy var cetificationNumberTextField : UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.tintColor = .white
        tf.textColor = .white
        tf.autocapitalizationType = .none //자동으로 대문자 만들어주는 옵션
        tf.autocorrectionType = .no //자동으로 틀린글자 잡아주는 옵션
        //tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    //로그인버튼
    private lazy var requestLoginButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4777786732, green: 0.50278157, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("로그인 하기", for: .normal)
        button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        //button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
 
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

   

}
