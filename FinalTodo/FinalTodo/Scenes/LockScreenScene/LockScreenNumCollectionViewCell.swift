//
//  LockScreenNumCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit

class LockScreenNumCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        contentView.backgroundColor = ColorManager.themeArray[0].pointColor02
        let width = (Constant.screenWidth - (Constant.defaultPadding * 2) - (Constant.defaultPadding * 2)) / 3
        contentView.layer.cornerRadius = width / 2
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
