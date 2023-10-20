//
//  LockScreenPasswordCollectionViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/19/23.
//

import UIKit
import SnapKit

class LockScreenPasswordCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(toggle: Bool) {
        if toggle {
            contentView.backgroundColor = ColorManager.themeArray[0].pointColor01
        } else {
            contentView.backgroundColor = ColorManager.themeArray[0].pointColor02
        }
        
    }
}

private extension LockScreenPasswordCollectionViewCell {
    func setUp() {
        contentView.layer.cornerRadius = Constant.screenWidth * 0.05 / 2
        contentView.backgroundColor = ColorManager.themeArray[0].pointColor02
    }
}
