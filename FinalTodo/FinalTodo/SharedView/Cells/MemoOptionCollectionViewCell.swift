//
//  memoOptionCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/12/23.
//

import UIKit

final class MemoOptionCollectionViewCell: UICollectionViewCell {
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
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

}

extension MemoOptionCollectionViewCell {
    func setUp() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = 0.4
        contentView.layer.cornerRadius = 9
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
