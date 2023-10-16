//
//  MemoListViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/13.
//

import UIKit
import SnapKit

class MemoListViewController: UIViewController {
    
    var memos: [Memo] = [
        Memo(title: "첫 번째 메모", date: Date(), folderName: "개인", folderColor: .red),
        Memo(title: "두 번째 메모", date: Date(), folderName: "업무", folderColor: .blue),
    ]
    
    var memoListView: MemoListView!
    let titleLabel = UILabel()
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
        
        setupMemoListView()
        setupNavigationBar()
    }
    
    private func setupMemoListView() {
        memoListView = MemoListView()
        view.addSubview(memoListView)
        memoListView.frame = view.bounds
        memoListView.tableView.delegate = self
        memoListView.tableView.dataSource = self
        memoListView.fab.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonTapped))
        titleLabel.text = "모든메모"
        navigationItem.titleView = titleLabel
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            
            let borderBottom = CALayer()
            borderBottom.backgroundColor = UIColor.gray.cgColor
            borderBottom.frame = CGRect(x: 0, y: navigationBar.frame.size.height, width: navigationBar.frame.size.width, height: 0.5)
            navigationBar.layer.addSublayer(borderBottom)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func fabTapped() {
    }
}

extension MemoListViewController: UITableViewDataSource {
    
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
        cell.backgroundColor = ColorManager.themeArray[0].backgroundColor
        
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    
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
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
    
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
        addSubview(separatorLine)
        
        folderColorView.layer.cornerRadius = 10
        arrowImageView.tintColor = .gray
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        folderNameLabel.textColor = .lightGray
        folderNameLabel.font = UIFont.systemFont(ofSize: 14)
        arrowImageView.tintColor = ColorManager.themeArray[0].pointColor01
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        
        folderColorView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        folderNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(folderColorView)
            make.left.equalTo(folderColorView.snp.right).offset(8)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        separatorLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}

struct Memo {
    let title: String
    let date: Date
    let folderName: String
    let folderColor: UIColor
}
