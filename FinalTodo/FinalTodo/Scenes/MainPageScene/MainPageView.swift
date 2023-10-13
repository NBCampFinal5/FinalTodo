//
//  MainPageView.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/13.
//

import UIKit
import SnapKit

class MainPageView: UIView {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelectionDuringEditing = true
        return tableView
    }()
    
    let fab: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(tableView)
        addSubview(fab)
        
        fab.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(self)
        }
    }
}
