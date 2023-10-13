//
//  AddMemoPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import UIKit
import SnapKit

class AddMemoPageViewController: UIViewController {

    lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "제목을 입력해 주세요."
        view.textColor = .systemGray
        view.backgroundColor = ColorManager.themeArray[0].pointColor02
        let inset = Constant.defaultPadding / 2
        view.textContainerInset = .init(top: inset, left: inset, bottom: inset, right: inset)
        view.layer.cornerRadius = inset
        return view
    }()
    private let memoView = MemoView()
    private let viewModel = AddMemoPageViewModel()

}

extension AddMemoPageViewController {
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorManager.themeArray[0].pointColor01
        setUp()
    }
    

}

private extension AddMemoPageViewController {
    // MARK: - setUp
    
    func setUp() {
        setUpTitleTextField()
        setUpMemoView()
    }
    
    func setUpTitleTextField() {
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
        titleTextView.delegate = self
    }
    
    func setUpMemoView() {
        view.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.bottom.equalToSuperview()
        }
        memoView.contentTextView.delegate = self
        memoView.optionCollectionView.delegate = self
        memoView.optionCollectionView.dataSource = self
    }

}

extension AddMemoPageViewController: UITextViewDelegate {
    // MARK: - TextViewPlaceHolder

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        switch textView {
        case titleTextView:
            if textView.text == "제목을 입력해 주세요." {
                textView.text = ""
                textView.textColor = .black
            }
            return true
        default:
            if textView.text == "메모를 입력해 주세요." {
                textView.text = ""
                textView.textColor = .black
            }
            return true
        }

    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        switch textView {
        case titleTextView:
            if textView.text == "" {
                textView.text = "제목을 입력해 주세요."
                textView.textColor = .systemGray
            }
            return true
        default:
            if textView.text == "" {
                textView.text = "메모를 입력해 주세요."
                textView.textColor = .systemGray
            }
            return true
        }

    }
    
    // MARK: - 유동적인 높이를 가진 textView
    func textViewDidChange(_ textView: UITextView) {
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

extension AddMemoPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.optionImageAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoOptionCollectionViewCell.identifier, for: indexPath) as! MemoOptionCollectionViewCell
        cell.bind(image: viewModel.optionImageAry[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
