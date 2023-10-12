//
//  memoOptionCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/12/23.
//

import UIKit

class MemoOptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MemoOptionCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
