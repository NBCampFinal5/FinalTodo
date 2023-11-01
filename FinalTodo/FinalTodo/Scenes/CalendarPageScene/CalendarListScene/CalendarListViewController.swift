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
    let calendarListView = CalendarListView()
    
    let date: Date
    var memos: [MemoData] = [] 
    
    init(date: Date) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension CalendarListViewController {
    func setUp() {
        view.addSubview(topView)
        view.addSubview(calendarListView)

        topView.backgroundColor = .systemBackground

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        calendarListView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
