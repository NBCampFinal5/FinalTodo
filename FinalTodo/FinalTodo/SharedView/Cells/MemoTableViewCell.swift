//
//  MemoTableViewCell.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/26.
//

import Foundation
import UIKit

class MemoCell: UITableViewCell {
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let folderNameLabel = UILabel()
    let folderColorView = UIView()
    let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .secondarySystemBackground
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(folderNameLabel)
        addSubview(folderColorView)
        // addSubview(arrowImageView)
        addSubview(separatorLine)
        
        folderColorView.layer.cornerRadius = 10
        arrowImageView.tintColor = .secondarySystemBackground
        dateLabel.textColor = .secondaryLabel
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        folderNameLabel.textColor = .secondaryLabel
        folderNameLabel.font = UIFont.systemFont(ofSize: 14)
        // arrowImageView.tintColor = .label
        accessoryType = .disclosureIndicator
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        
        folderColorView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        folderNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(folderColorView)
            make.left.equalTo(folderColorView.snp.right).offset(8)
        }
        
//        arrowImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-10)
//            make.size.equalTo(CGSize(width: 20, height: 20))
//        }
        
        separatorLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
