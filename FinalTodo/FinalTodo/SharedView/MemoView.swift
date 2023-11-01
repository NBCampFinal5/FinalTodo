//
//  MemoView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/12.
//

import SnapKit
import UIKit

final class MemoView: UIView {
    // MARK: - Property

    lazy var optionCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Constant.defaultPadding
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.tintColor = .systemBackground
        return view
    }()

    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.text = "메모를 입력해 주세요."
        view.textColor = .systemGray
        view.backgroundColor = .gray
        view.textContainerInset = .init(top: 0, left: Constant.defaultPadding, bottom: 0, right: Constant.defaultPadding)
        return view
    }()

    lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MemoView {
    // MARK: - SetUp

    func setUp() {
        setUpOptionCollectionView()
        setUpContentTextView()
        setUptagsLabel()
    }

    func setUpOptionCollectionView() {
        addSubview(optionCollectionView)
        optionCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.03)
        }
        optionCollectionView.register(MemoOptionCollectionViewCell.self, forCellWithReuseIdentifier: MemoOptionCollectionViewCell.identifier)
    }

    func setUpContentTextView() {
        addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(optionCollectionView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func setUptagsLabel() {
        addSubview(tagsLabel)
        tagsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constant.defaultPadding)
        }
    }
}
