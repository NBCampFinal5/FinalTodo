//
//  SettingCell.swift
//  FinalTodo
//
//  Created by SR on 2023/10/11.
//

import SnapKit
import UIKit

class SettingCell: UITableViewCell {
    
//    let identifier = #function
//    // #function: 현재 위치에서 사용 중인 함수 또는 메서드의 이름을 나타내는 키워드
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tertiaryLabel
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
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
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Constant.screenWidth / 15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(Constant.defaultPadding)
            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Constant.screenWidth / 15)
        }
    }
    
    func configure(with option: SettingOption) {
        iconImageView.image = UIImage(systemName: option.icon)
        titleLabel.text = option.title
        
//        print(option.icon)
    }
}
