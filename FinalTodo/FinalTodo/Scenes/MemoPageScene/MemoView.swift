//
//  MemoView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/12.
//

import UIKit
import SnapKit

class MemoView: UIView {
    // MARK: - Property
    
    lazy var optionCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .green
        return view
    }()
    
    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.backgroundColor = .green
        return view
    }()
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MemoView {
    // MARK: - SetUp

    func setUp() {
        setUpOptionCollectionView()
        setUpContentTextView()
    }
    
    func setUpOptionCollectionView() {
        self.addSubview(optionCollectionView)
        optionCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    func setUpContentTextView() {
        self.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(optionCollectionView.snp.bottom).offset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.bottom.equalToSuperview()
        }
    }
}
