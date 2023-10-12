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
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        memoView.contentTextView.delegate = self
    }
    // MARK: - SetUpNavigation
    func setUpNavigation() {
        self.navigationItem.title = "title"
    }

}

extension MemoViewController: UITextViewDelegate {
    // MARK: - 유동적인 높이를 가진 textView
    func textViewDidChange(_ textView: UITextView) {
        
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
}
