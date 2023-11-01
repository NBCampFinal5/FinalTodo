//
//  CalendarListView.swift
//  FinalTodo
//
//  Created by SR on 2023/11/01.
//

import UIKit

class CalendarListView: UIView {
    var tableView: UITableView!

    init() {
        super.init(frame: .zero)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarListView {
    func setUp() {
        addSubview(tableView)
        tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")

        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(self)
        }
    }
}
