//
//  MemoView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/12.
//

import UIKit
import SnapKit

protocol MemoViewTextViewDelegate: UIViewController {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    func textViewShouldEndEditing(textView: UITextView) -> Bool
    func textViewDidChange(textView: UITextView)

}

protocol MemoViewCollectionViewDelegate: UIViewController {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}


class MemoView: UIView {
    // MARK: - Property
    
    private let scrollView = UIScrollView()
    
    private let scrollContentView = UIView()
    
    lazy var optionCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        let itemSize = Constant.screenHeight * 0.05
        let spacing = Constant.defaultPadding
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        view.backgroundColor = .green
        return view
    }()
    
    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "메모를 입력해 주세요."
        view.textColor = .systemGray
//        view.backgroundColor = .green
        return view
    }()
    
    weak var textViewDelegate: MemoViewTextViewDelegate?
    
    weak var collectionViewDelegate: MemoViewCollectionViewDelegate?
    
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
        setUpScrollView()
        setUpOptionCollectionView()
        setUpContentTextView()
    }
    
    func setUpScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
    }
    
    func setUpOptionCollectionView() {
        scrollContentView.addSubview(optionCollectionView)
        optionCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.register(MemoOptionCollectionViewCell.self, forCellWithReuseIdentifier: MemoOptionCollectionViewCell.identifier)
    }
    
    func setUpContentTextView() {
        scrollContentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(optionCollectionView.snp.bottom).offset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        contentTextView.delegate = self
    }
}

extension MemoView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let delegate = textViewDelegate else { return true}
        return delegate.textViewShouldBeginEditing(textView: textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let delegate = textViewDelegate else { return true}
        return delegate.textViewShouldEndEditing(textView: textView)
    }
    func textViewDidChange(_ textView: UITextView) {
        textViewDelegate?.textViewDidChange(textView: textView)
    }
}

extension MemoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let delegate = collectionViewDelegate else { return 0}
        return delegate.collectionView(collectionView: collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let delegate = collectionViewDelegate else { return UICollectionViewCell()}
        return delegate.collectionView(collectionView: collectionView, cellForItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let delegate = collectionViewDelegate else { return UIEdgeInsets()}
        return delegate.collectionView(collectionView: collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }
    
}
