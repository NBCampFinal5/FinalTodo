//
//  MainPageView.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/13.
//

import UIKit
import SnapKit

class MainPageView: UIView {
    
    var tableView: UITableView!
    var fab: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        tableView = UITableView()
        tableView.backgroundColor = ColorManager.themeArray[0].backgroundColor
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelectionDuringEditing = true
        addSubview(tableView)
        
        fab = UIButton(type: .custom)
        fab.backgroundColor = ColorManager.themeArray[0].pointColor01
        fab.layer.cornerRadius = 28
        fab.setImage(UIImage(systemName: "plus"), for: .normal)
        fab.tintColor = .white
        addSubview(fab)
    }
    
    private func setupConstraints() {
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
