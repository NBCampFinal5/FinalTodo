//
//  NotifySettingItemView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/15/23.
//

import UIKit
import SnapKit

class NotifySettingItemView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var stateSwitch = UISwitch()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.themeArray[0].pointColor02
        return view
    }()
    
    // MARK: - init

    init(title: String) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension NotifySettingItemView {
    func setUp() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        self.addSubview(stateSwitch)
        stateSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constant.defaultPadding)
            make.centerY.equalToSuperview()
        }
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
