//
//  MemoListViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/13.
//

import SnapKit
import UIKit

// MARK: - 파일 분리 요망

class MemoListViewController: UIViewController {
    var memos: [MemoData] = []

//    var memos: [Memo] = [
//        Memo(title: "첫 번째 메모", date: Date(), folderName: "개인", folderColor: .red, content: ""),
//        Memo(title: "두 번째 메모", date: Date(), folderName: "업무", folderColor: .blue, content: ""),
//    ]
    
    var memoListView: MemoListView!
    let titleLabel = UILabel()
    var folder: Folder!
    
    init(folder: Folder) {
        super.init(nibName: nil, bundle: nil)
        self.folder = folder
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemos()
        setupMemoListView()
        setupNavigationBar()
    }

    func loadMemos() {
        memos = CoreDataManager.shared.getMemos()
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
        if let navigationBar = navigationController?.navigationBar {
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
    
    @objc func fabTapped() {
        let addMemoVC = AddMemoPageViewController()
        addMemoVC.transitioningDelegate = self
        addMemoVC.modalPresentationStyle = .custom
        present(addMemoVC, animated: true, completion: nil)
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
            
        let memo = memos[indexPath.row]
            
        cell.titleLabel.text = memo.content
        cell.dateLabel.text = memo.date
            
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
              let memoToDelete = self.memos[indexPath.row]
              CoreDataManager.shared.deleteMemo(targetId: memoToDelete.id) {
                  self.memos.remove(at: indexPath.row)
                  tableView.deleteRows(at: [indexPath], with: .fade)
                  completion(true)
              }
          }
          
          return UISwipeActionsConfiguration(actions: [deleteAction])
      }
    
}

extension MemoListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
    }
}

struct Memo {
    var title: String
    var date: Date
    var folderName: String
    var folderColor: UIColor
    var content: String
}
