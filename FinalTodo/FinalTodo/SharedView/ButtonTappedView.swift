//
//  LoginView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import UIKit
import SnapKit

class ButtonTappedView: UIView {
    weak var delegate: ButtonTappedViewDelegate?
    
    //버튼
    private lazy var anyButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "theme01PointColor03")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        //button.isEnabled = false //버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        self.anyButton.setTitle(title, for: .normal)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension ButtonTappedView {
    func setup(){
        setupButton()
    }
    //오토레이아웃
    func setupButton(){
        self.addSubview(anyButton)
        anyButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
            make.bottom.equalToSuperview()
        }
    }
}


extension ButtonTappedView {

    @objc func buttonTapped() {
            // 버튼이 탭되었을 때 실행할 코드
            if anyButton.isEnabled {
                // 버튼이 활성화되어 있을 때 실행할 동작
            } else {
                // 버튼이 비활성화되어 있을 때 실행할 동작
            }
        }
    
    var isEnabled: Bool {
        get {
            return anyButton.isEnabled
        }
        set {
            anyButton.isEnabled = newValue
        }}
    
    func changeButtonColor (color: UIColor?) {
        anyButton.backgroundColor = color
    }
}



