//
//  ModalTopView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import UIKit
import SnapKit

class ModalTopView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.screenHeight * 0.05, weight: .light)
//        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: imageConfig)
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = ColorManager.themeArray[0].pointColor02
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.themeArray[0].pointColor02
        return view
    }()

    init(title: String) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        setUp()
        
    }
    
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
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
//            make.height.width.equalTo(Constant.screenHeight * 0.0)
            make.top.right.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    func setUpDivider() {
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(Constant.defaultPadding)
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
