//
//  MemoViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/12.
//

import UIKit
import SnapKit

class MemoViewController: UIViewController {
    
    private let memoView = MemoView()
}

extension MemoViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpNavigation()
    }
}

private extension MemoViewController {
    // MARK: - SetUp
    func setUp() {
        setUpMemoView()
    }
    
    func setUpMemoView() {
        view.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        memoView.delegate = self
    }
    // MARK: - SetUpNavigation
    func setUpNavigation() {
        self.navigationItem.title = "title"
    }
}

extension MemoViewController: MemoViewDelegate {
    
    // MARK: - 유동적인 높이를 가진 textView
    func textViewDidChange(textView: UITextView) {
        let size = CGSize(width: Constant.screenWidth - (Constant.defaultPadding * 2), height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if estimatedSize.height > Constant.screenHeight * 0.05 {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoOptionCollectionViewCell.identifier, for: indexPath) as! MemoOptionCollectionViewCell
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemSize = Constant.screenHeight * 0.05
        let spacing = Constant.defaultPadding
        let count: CGFloat = 5
        let totalCellWidth = itemSize * count
        let totalSpacingWidth = spacing * (count - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

