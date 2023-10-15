//
//  SettingCell.swift
//  FinalTodo
//
//  Created by SR on 2023/10/11.
//

import SnapKit
import UIKit

class SettingCell: UITableViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constant.defaultPadding
        stackView.alignment = .fill
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = ColorManager.themeArray[0].backgroundColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.themeArray[0].backgroundColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 15)
        }
    }
    
    func configure(with option: SettingOption) {
        iconImageView.image = UIImage(systemName: option.icon)
        titleLabel.text = option.title
    }
}
