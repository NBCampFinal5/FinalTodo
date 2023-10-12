//
//  ThemeColorCell.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import SnapKit
import UIKit

class ThemeColorCell: UITableViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.defaultPadding
        stackView.alignment = .leading
        return stackView
    }()
    
    private let colorImageView01: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let colorImageView02: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let colorImageView03: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(colorImageView01)
        stackView.addArrangedSubview(colorImageView02)
        stackView.addArrangedSubview(colorImageView03)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(chevronImageView)
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Constant.screenWidth / 12)
        }
        
        colorImageView01.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 12)
        }
        colorImageView02.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 12)
        }
        colorImageView03.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 12)
        }
        chevronImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 15)
        }
//
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(iconImageView.snp.right).offset(Constant.defaultPadding)
//            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
//            make.centerY.equalTo(contentView)
//        }
//
//        chevronImageView.snp.makeConstraints { make in
//            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
//            make.centerY.equalTo(contentView)
//            make.width.height.equalTo(Constant.screenWidth / 15)
//        }
    }
    
    func configure(with option: ThemeColorOption) {
//        colorImageView01.tintColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        colorImageView01.tintColor = option.Color01
        colorImageView02.tintColor = option.Color02
        colorImageView03.tintColor = option.Color03
        titleLabel.text = option.title
    }
}
