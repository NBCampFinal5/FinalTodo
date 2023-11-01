//
//  MemoListView.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/16.
//

import UIKit

class MemoListView: UIView {
    var tableView: UITableView!
    var fab: UIButton!
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")
        addSubview(tableView)
        
//        fab = UIButton(type: .custom)
////        fab.backgroundColor = .myPointColor
//        fab.layer.cornerRadius = 28
//        fab.layer.borderWidth = 1
//        fab.layer.borderColor = UIColor.label.cgColor
//        fab.setImage(UIImage(systemName: "plus"), for: .normal)
//        fab.tintColor = .label
//        addSubview(fab)
        fab = UIButton(type: .custom)
        fab.backgroundColor = .myPointColor
        fab.layer.cornerRadius = 28
        fab.setImage(UIImage(systemName: "plus"), for: .normal)
        
        fab.tintColor = .systemBackground
        addSubview(fab)
    }
    
    private func setupConstraints() {
        fab.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(self)
        }
    }
}
