//
//  MemoViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/12.
//

import UIKit
import SnapKit

final class MemoViewController: UIViewController {
    
    private let memoView = MemoView()
    private let viewModel = MemoViewModel()
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
        self.view.backgroundColor = ColorManager.themeArray[0].pointColor01
        setUpMemoView()
    }
    
    func setUpMemoView() {
        view.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
        }
        memoView.textViewDelegate = self
        memoView.collectionViewDelegate = self
    }
    // MARK: - SetUpNavigation
    func setUpNavigation() {
        self.navigationItem.title = "title"
    }
}

extension MemoViewController {
    // MARK: - Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension MemoViewController: MemoViewTextViewDelegate {
    // MARK: - TextViewPlaceHolder

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == "메모를 입력해 주세요." {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = "메모를 입력해 주세요."
            textView.textColor = .systemGray
        }
        return true
    }
    
    // MARK: - 유동적인 높이를 가진 textView
    func textViewDidChange(textView: UITextView) {
        let size = CGSize(width:textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if estimatedSize.height > Constant.screenHeight * 0.05 {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}

extension MemoViewController: MemoViewCollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.optionImageAry.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoOptionCollectionViewCell.identifier, for: indexPath) as! MemoOptionCollectionViewCell
        cell.bind(image: viewModel.optionImageAry[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
