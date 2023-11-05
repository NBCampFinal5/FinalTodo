//
//  MainPageView.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/13.
//

import SnapKit
import UIKit

class MainPageView: UIView {
    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.allowsSelectionDuringEditing = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var fab: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)
        
        fab = UIButton(type: .custom)
        fab.backgroundColor = .myPointColor
        fab.layer.cornerRadius = 28
        fab.setImage(UIImage(systemName: "plus"), for: .selected)
        fab.isSelected = true
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
