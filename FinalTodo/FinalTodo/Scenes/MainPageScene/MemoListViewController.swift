//
//  MemoListViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/13.
//

import UIKit
import SnapKit

class MemoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var memos: [Memo] = [
        Memo(title: "첫 번째 메모", date: Date(), folderName: "개인", folderColor: .red),
        Memo(title: "두 번째 메모", date: Date(), folderName: "업무", folderColor: .blue),
    ]
    
    var tableView = UITableView()
    let titleLabel = UILabel()
    let fab: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var folder: Folder!
    
    init(folder: Folder) {
        super.init(nibName: nil, bundle: nil)
        self.folder = folder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        setupNavigationBar()
        setupTableView()
        setupFAB()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTapped))
        titleLabel.text = "모든메모"
        navigationItem.titleView = titleLabel
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(view)
        }
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")
        tableView.allowsSelectionDuringEditing = true
        
        view.bringSubviewToFront(fab)
    }
    
    private func setupFAB() {
        view.addSubview(fab)
        
        fab.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        fab.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func fabTapped() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        
        let memo = memos[indexPath.row]
        
        cell.titleLabel.text = memo.title
        cell.dateLabel.text = DateFormatter.localizedString(from: memo.date, dateStyle: .short, timeStyle: .short)
        cell.folderNameLabel.text = memo.folderName
        cell.folderColorView.backgroundColor = memo.folderColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completion) in
            self.memos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

class MemoCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let folderNameLabel = UILabel()
    let folderColorView = UIView()
    let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(folderNameLabel)
        addSubview(folderColorView)
        addSubview(arrowImageView)
        
        folderColorView.layer.cornerRadius = 10
        arrowImageView.tintColor = .gray
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
        }
        
        folderColorView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        folderNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(folderColorView)
            make.left.equalTo(folderColorView.snp.right).offset(5)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
}

struct Memo {
    let title: String
    let date: Date
    let folderName: String
    let folderColor: UIColor
}
