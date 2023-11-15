//
//  ModalTopView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import SnapKit
import UIKit

class ModalTopView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .myPointColor
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        return view
    }()

    init(title: String) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ModalTopView {
    func setUp() {
        setUpBackButton()
        setUpTitleLabel()
        setUpDivider()
    }
    
    func setUpBackButton() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Constant.defaultPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    func setUpDivider() {
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(Constant.defaultPadding)
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
