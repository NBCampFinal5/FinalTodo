//
//  LoginView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import SnapKit
import UIKit

class ButtonTappedView: UIView {
    // 버튼
    private lazy var anyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "theme01PointColor01")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.isEnabled = false // 버튼을 비활성화 해주는 코드(나중에 색깔 변하게 해서 활성화 시켜줄거임
        return button
    }()

    init(title: String) {
        super.init(frame: CGRect.zero)
        anyButton.setTitle(title, for: .normal)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ButtonTappedView {
    func setup() {
        setupButton()
    }

    // 오토레이아웃

    func setupButton() {
        addSubview(anyButton)
        anyButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
}
