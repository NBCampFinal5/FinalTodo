//
//  LoginView.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/16/23.
//

import SnapKit
import UIKit

class ButtonTappedView: UIView {
    weak var delegate: ButtonTappedViewDelegate?

    // 버튼
    lazy var anyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .label
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
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
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
            make.bottom.equalToSuperview()
        }
    }
}

extension ButtonTappedView {
    @objc func buttonTapped(_ button: UIButton) {
        delegate?.didTapButton(button: button)
    }

    func setButtonEnabled(_ enabled: Bool) {
        anyButton.isEnabled = enabled
    }

    func changeButtonColor(color: UIColor?) {
        anyButton.backgroundColor = color
    }

    func changeTitleColor(color: UIColor?) {
        anyButton.setTitleColor(color, for: .normal)
    }
}
