//
//  memoOptionCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/12/23.
//

import UIKit

final class MemoOptionCollectionViewCell: UICollectionViewCell {
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = ColorManager.themeArray[0].pointColor01
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(title: String) {
        categoryLabel.text = title
    }
    
    // 성준 - 배경색 변경 메소드 추가
    func changeBackgroundColor(to color: UIColor) {
        contentView.backgroundColor = color
    }
}

extension MemoOptionCollectionViewCell {
    func setUp() {
        contentView.backgroundColor = ColorManager.themeArray[0].pointColor02
        contentView.layer.cornerRadius = 8
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
