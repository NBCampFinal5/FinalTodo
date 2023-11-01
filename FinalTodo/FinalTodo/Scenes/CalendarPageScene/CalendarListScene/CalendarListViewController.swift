//
//  CalendarListViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/31.
//

import UIKit

class CalendarListViewController: UIViewController {
    let viewModel = CalendarPageViewModel()

    let topView = ModalTopView(title: "")
    let memoListView = MemoListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension CalendarListViewController {
    func setUp() {
        view.addSubview(topView)
        view.addSubview(memoListView)

        topView.backgroundColor = .systemBackground

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        memoListView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
