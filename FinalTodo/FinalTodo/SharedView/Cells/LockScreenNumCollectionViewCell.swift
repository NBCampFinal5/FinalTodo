//
//  LockScreenNumCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit
import SnapKit

class LockScreenNumCollectionViewCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "test"
        label.textAlignment = .center
        label.textColor = .systemBackground
        
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
        label.text = title
    }
    
    func getTitle() -> String {
        guard let text = label.text else {return ""}
        return text
    }
}

private extension LockScreenNumCollectionViewCell {
    func setUp() {
        contentView.backgroundColor = .systemGray4
        let spacing = Constant.defaultPadding * 2
        let width = (Constant.screenWidth - (Constant.defaultPadding * 6) - (spacing * 2)) / 3
        contentView.layer.cornerRadius = width / 2
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
