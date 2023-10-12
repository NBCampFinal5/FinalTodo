//
//  memoOptionCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/12/23.
//

import UIKit

class MemoOptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MemoOptionCollectionViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(image:UIImage?) {
        imageView.image = image
    }
    
}

private extension MemoOptionCollectionViewCell {
    func setUp() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
