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
        stackView.spacing = Constant.defaultPadding
        stackView.alignment = .fill
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
        label.textColor = .label
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
        stackView.addArrangedSubview(colorImageView01)
        stackView.addArrangedSubview(colorImageView02)
        stackView.addArrangedSubview(colorImageView03)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
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
    }
    
    func configure(with option: ThemeColorOption) {
        colorImageView01.tintColor = option.Color01
        colorImageView02.tintColor = option.Color02
        colorImageView03.tintColor = option.Color03
        titleLabel.text = option.title
    }
}
