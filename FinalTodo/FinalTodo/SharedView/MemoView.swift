//
//  MemoView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/12.
//

import UIKit
import SnapKit

final class MemoView: UIView {
    // MARK: - Property
    
    lazy var optionCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Constant.defaultPadding
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.tintColor = .systemBackground
        return view
    }()
    
    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.text = "메모를 입력해 주세요."
        view.textColor = .systemGray
        view.backgroundColor = .clear
        view.textContainerInset = .init(top: 0, left: Constant.defaultPadding, bottom: 0, right: Constant.defaultPadding)
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
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.03)
        }
        optionCollectionView.register(MemoOptionCollectionViewCell.self, forCellWithReuseIdentifier: MemoOptionCollectionViewCell.identifier)
    }
    
    func setUpContentTextView() {
        self.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(optionCollectionView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
