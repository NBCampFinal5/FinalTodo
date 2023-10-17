//
//  LoginView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import UIKit
import SnapKit

class buttonTappedView: UIView {

    
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
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension buttonTappedView {
    func setup(){
        setupButton()
    }
    //오토레이아웃
    
    
    func setupButton(){
        self.addSubview(anyButton)
        anyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.09)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
    }
}



